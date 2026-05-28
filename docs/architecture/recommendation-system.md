# Recommendation System v2 — Architecture

**Status:** in progress
**Branch:** `feature/recommendation-system-improvements`
**Owner:** auction_center team
**Last updated:** 2026-05-27

## Goal

Personalised auction feed on `/auctions` index that ranks domains by combining:

1. User's explicit interests (recommendation profile)
2. Wishlist (current + historical)
3. Bid history including finished auctions (`Offer`, `EnglishOffer`, `DomainOfferHistory`)
4. Detail-page views (with dwell-time signal)
5. Auction outcomes (`Result` — won/lost)

Sort is **per-user**. Same `/auctions` request returns N different orderings for N users.

## Non-goals

- No global feed cache (sort is per-user)
- No client-side ranking for v2 (server is the source of truth)
- No real-time LLM calls during user requests (LLM is batch-only, cron-driven)
- **No pgvector** — pgvector was evaluated and dropped to avoid shared-
  infrastructure churn (RDS extensions, Docker image bumps for the team-shared
  Postgres). Instead, embeddings are stored as plain Postgres `double precision[]`
  arrays and cosine similarity is computed in Ruby. At 100-200 active auctions
  this is sub-100ms and zero new infrastructure. See ADR-001.

## High-level data flow

```
Domain enters system (Auction.create / WishlistItem.create / Offer.create / DomainOfferHistory)
   |
   v
ClassifyDomainHeuristicallyJob  (instant, Ruby-only, no external calls)
   |
   v
domain_classifications row created with source='heuristic'
   |
   v
   |---> Scorer uses these tags/keywords immediately
   |
   v
[ Nightly k8s CronJob: rake recommendation:classify_unclassified ]
   |
   v
LLM batch (50 domains / call) enriches rows with keywords, audience,
suggested_use_cases, brandability_score, languages
source='openai'
   |
   v
Scorer per user-event:
  bid affinity, wishlist affinity, view affinity, time decay,
  tag/keyword overlap, structural bonuses
   |
   v
user_auction_scores (upsert, unique on user_id + auction_id)
   |
   v
Auction::UserSortable.with_user_priority_sorting(user)
   |
   v
/auctions index — sorted per user
```

## Key tables

### `domain_classifications` (new)

Single source of truth for what a domain *means*. One row per `domain_name`.

| column | purpose |
|---|---|
| `domain_name` (unique) | the key |
| `primary_category`, `tags[]` | hard categorical signals |
| `keywords[]` | extracted semantic tokens, shown in UI as badges |
| `audience` (b2b/b2c/mixed) | targeting signal |
| `languages[]` | et / en / mixed |
| `suggested_use_cases[]` | shop / blog / service / agency / marketplace |
| `has_digits`, `has_hyphens`, `token_count`, `dictionary_word`, `brandability_score` | structural cache |
| `classification_source` | heuristic / openai / manual / imported |
| `confidence` (0..1) | gate for "stale, needs LLM re-run" |
| `raw_llm_response` (jsonb) | audit trail, allows re-parsing without re-billing |

### `recommendation_events` (existing)

Append-only log of user behaviour. Used both for scoring inputs and analytics.

### `user_auction_scores` (existing)

Per-user × per-active-auction precomputed score. Updated by `Recommendation::Scorer` on user events. **This is the personalisation cache.** LEFT JOINed by `Auction::UserSortable`.

### `recommendation_profiles` (existing)

Explicit user preferences (interests, length, digit/hyphen tolerance).

## Classification tiers

```
Tier 0 — Structural + Heuristic (Ruby, instant, free)
  - DomainStructuralAnalyzer: has_digits, has_hyphens, token_count, dictionary_word
  - DomainHeuristicClassifier: dictionary lookup (et+en roots), subword tokenizer
  - Coverage: ~60-70% Estonian domains, ~30% English
  - Output: tags, keywords, confidence

Tier 2 — LLM batch (cron daily, ~$0.30/month at our volume)
  - Recommendation::LlmDomainClassifier
  - OpenAI structured output (json_schema)
  - 50 domains per API call
  - Enriches keywords, audience, suggested_use_cases, brandability_score, languages
  - Re-runs every 6 months for source='openai' rows

Tier 1 — (future, optional) embedding-based local classifier
  - Not in v2 scope. Pending data accumulation from Tier 2.
```

## Cron jobs (k8s CronJob, NOT in-app scheduler)

| schedule | task | purpose |
|---|---|---|
| `0 3 * * *` (03:00 daily) | `rake recommendation:classify_unclassified` | Tier 2 enrichment for heuristic-only/low-confidence/stale rows |
| `30 3 * * *` (03:30 daily) | `rake recommendation:embed_unembedded` | OpenAI embeddings for classified-but-unembedded rows (stored as float[]) |
| one-shot | `rake recommendation:backfill` | Initial classification of all historical domains |

K8s manifests live in `Ry_AWS_IaC/infrastructure/kubernetes` — outside this repo.

## Scorer signals (v2)

Final score per (user, auction) is a weighted sum + multiplier:

```
score = 0
  + 120                                    if wishlist hit
  + matching_tags        * 35              category overlap
  + matching_keywords    * 15              keyword overlap
  + audience_match       * 10              dominant-audience inference
  + bid_feature_aggregate (decay-weighted) uses domain_classifications
  + wishlist_feature_aggregate (decay)     uses domain_classifications
  + view_feature_aggregate (decay)         from auction_detail_view events
  + similar_to_saved_domain * 15
  + preferred_length_match * 10
  + digit_score                            -20 .. +8
  + hyphen_score                           -12 .. +5
  + ai_prior_score                         existing legacy
  + domain_offer_history_signal            historical bids
  + result_signal                          won: weak negative; lost: strong positive

multiplier = 1 + max(0, cosine_similarity(user_centroid, auction.embedding))
score = score * multiplier
```

User centroid = time-decayed weighted average of embeddings from the user's
bids + wishlist + recent views. Multiplier is a no-op (1.0) when the user has
no history or the auction is not yet embedded.

Time decay: `weight *= exp(-days_old / 60)` (half-life 60 days).

## Infrastructure dependencies

| Dependency | Source | Status |
|---|---|---|
| OpenAI API | existing integration via `Feature.open_ai_integration_enabled?` | reused |
| K8s CronJobs | maintained in `Ry_AWS_IaC` | scheduled by infra team |

**No infrastructure changes are required for v2.** No new extensions on RDS,
no Docker image bumps, no schema changes outside the auction_center database.

## Cost estimate

- **Backfill** (one-time): ~5000 historical unique domains
  - LLM classify: ~100 batches × ~3000 tokens = **~$0.50-1**
  - Embeddings: 5000 × ~50 tokens × $0.02/M = **~$0.005**
- **Steady state** (per day):
  - LLM classify: 5-20 new domains/day, batched = 0-1 OpenAI call = **~$0.01/day**
  - Embeddings: 1 call/day = **~$0.0001/day**
  - Total: **~$0.30/month**

## Implementation phases

See [domain-classification-pipeline.md](../technical/domain-classification-pipeline.md) for pipeline details. Phase-by-phase task tracking lives in the project task list.

| Phase | What | Status |
|---|---|---|
| 0 | Snapshot + docs scaffold | done |
| 1 | Performance foundation (batch impressions, debounce score refresh) | done |
| 2 | `domain_classifications` table + heuristic Tier 0 | done |
| 3a | DomainClassifier orchestrator (heuristic only) | done |
| 3b | LLM batch enrichment job (cron) | done |
| 4 | Triggers + backfill rake | done |
| 5 | Embedding similarity via Postgres `double precision[]` (no pgvector) | done |
| 6 | Rich-feature Scorer + embedding similarity + time decay | done |
| 7 | Detail view tracking + view affinity | done |
| 8 | Show domain keywords as badges in auction card | done |
| 9 | Polish + finalize | done |

Operator runbook: see [guides/recommendation-operations.md](../guides/recommendation-operations.md).

## Open questions / future work

- **Tier 1 local ML classifier** — after enough Tier 2 training data accumulates (~1000 LLM-classified rows), consider training a small linear classifier on character-ngram BoW + Tier 2 labels. Removes most LLM cost. Out of v2 scope.
- **Client-side in-session re-ranker** — locally upweight cards user clicked in this session, without server roundtrip. Out of v2 scope.
- **Auction.classification_* columns deprecation** — keep as fallback for 1-2 releases, then drop.

## Non-personal sort fallback

For new users with no `user_auction_scores` and no history, `Auction::UserSortable` falls back to existing `ai_score` + `RANDOM()` tiers. Same path for unauthenticated visitors.
