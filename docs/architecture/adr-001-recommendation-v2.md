# ADR 001 — Recommendation system v2 design

**Status:** Accepted
**Date:** 2026-05-27
**Branch:** `feature/recommendation-system-improvements`

## Context

The v1 recommendation system shipped on the same branch coupled classification
to the `auctions` table (`auctions.classification_tags`, `primary_category`,
`classification_source`), called the OpenAI LLM eagerly per event, and computed
scores synchronously inside controllers' callback paths. Operating it revealed
three structural problems:

1. **Per-event LLM cost was unbounded.** Each new auction or wishlist add could
   eventually trigger an LLM call, with no upper bound on monthly spend.
2. **Domains outside `auctions` were invisible to the recommender.** Wishlist
   items whose domain never went to auction had no tags — wishlist affinity
   silently no-op'd.
3. **Self-learning loop was broken for historical auctions.** Classification only
   ran on currently active auctions, so a user's old bid history could not feed
   tag affinity unless the domain happened to be on an active auction *and* had
   already been classified.

Plus operational concerns: per-impression INSERTs on `/auctions` index, no
debouncing on score recompute, no embeddings for similarity search, no time
decay on behavioural signals.

## Decisions

### D1. Classification lives on a per-domain table, not per-auction columns

A new `domain_classifications` table is the single source of truth for what a
domain *means*. Unique by `domain_name`. Auctions, wishlist items, offer
histories, and result records all reference it indirectly via `domain_name`.

**Why:** The semantics of `cloud-shop.ee` don't change between auctions. Storing
tags per auction duplicates state and prevents non-auction inputs (wishlist,
historical bids) from contributing to scoring.

**Cost:** A migration. Legacy `auctions.classification_*` columns stay populated
during transition as fallback; planned removal after v2 stabilises.

### D2. Three-tier classifier pipeline (Ruby → LLM-batch → embeddings)

- **Tier 0** — `DomainHeuristicClassifier`, deterministic Ruby with an et+en
  dictionary, runs at runtime on every event. Covers ~60-70% of Estonian
  domains, free, microsecond-scale.
- **Tier 2** — `LlmDomainClassifier`, structured-output OpenAI call, batched 50
  domains per request. Runs ONLY from cron (`rake recommendation:classify_unclassified`),
  never from request paths.
- **Embeddings** — `DomainEmbedder` using `text-embedding-3-small`, batched 100
  per call. Same cron-only constraint.

**Why:** Decouples user-facing latency from OpenAI variability and bounds
monthly cost. At our auction volume (100-200 active) steady-state OpenAI cost
is ~$0.30/month, with ~$1 one-time backfill.

**Alternative considered:** WASM-based on-device classifier. Rejected for v2
because classification is computed once per domain and cached; the bandwidth
cost of shipping a 10MB model to every browser exceeds the savings.

### D3. AWS RDS-native pgvector, no Dockerfile changes

`vector` extension is in the RDS Postgres 17 allowlist. Migration calls
`enable_extension 'vector'`. If the app role lacks `CREATE EXTENSION`, an
operator runs the SQL once manually as `rds_superuser`. No changes required to
`Dockerfile`, `Dockerfile.staging`, `Dockerfile.test` (these are app-runtime
images — pgvector belongs on the DB host).

**Why:** Lowest-friction route. Considered: separate Postgres image with
pre-baked pgvector. Rejected because RDS doesn't allow custom Postgres images.

### D4. Cron jobs scheduled outside the app

The application exposes rake tasks (`recommendation:classify_unclassified`,
`recommendation:embed_unembedded`, `recommendation:backfill`) and registers
the underlying jobs in `Job::ALLOWED_JOB_NAMES`. Scheduling lives in
`Ry_AWS_IaC/infrastructure/kubernetes` as k8s `CronJob` resources.

**Why:** Matches the project's existing pattern — server-side scheduling is
infra concern, app exposes idempotent entry points. Avoids an in-process
scheduler (whenever, sidekiq-cron, good_job).

### D5. Time-decayed behavioural signals, no SQL date cutoff

Bid, wishlist, view, and result signals are weighted by
`exp(-days_old / HALF_LIFE_DAYS)` with `HALF_LIFE_DAYS = 60`. No `WHERE
updated_at > X` clause; decay alone reduces multi-year-old signals below the
floating-point noise floor.

**Why:** SQL date cutoffs interact badly with `travel_to` in tests and with
clock skew across regions. Decay is mathematically equivalent and simpler to
reason about.

### D6. Embedding multiplier, not additive

Final score = base_score * (1 + max(0, cosine_similarity)). User centroid is
the time-decayed weighted average of embeddings from bids, wishlist, and views.

**Why:** Multiplicative form lets embedding act as a "boost knob" — it can't
introduce a high score in isolation (no behavioural data → no centroid → 1.0),
but it can lift a domain that other signals already mildly favour. Additive
form risks dominating the rule-based base when cosine is small.

### D7. Heuristic-only at runtime, LLM-only via cron

`ClassifyDomainHeuristicallyJob` (Tier 0) fires from `Auction.after_create`,
`WishlistItem#create`, and offer controllers. `ClassifyUnclassifiedDomainsJob`
(Tier 2) fires only from cron. There is no code path that triggers an LLM call
in response to a user request.

**Why:** Bounds cost, hides OpenAI latency from users, makes the system
predictable to operate.

## Consequences

**Positive**
- Cost bound to ~$0.30/month steady state, ~$1 one-time backfill.
- No user-visible latency tied to OpenAI.
- Wishlist and historical bids on non-auction domains now contribute to
  recommendations.
- Embedding-based similarity available for future "domains like this" features.
- Time decay means stale interests fade automatically; recent activity weighs
  more.

**Negative**
- Two writes per domain (heuristic, then LLM enrichment). Acceptable because
  Tier 0 produces useful tags immediately while Tier 2 enriches overnight.
- More tables to operate. Mitigated by the operator runbook in
  `docs/guides/recommendation-operations.md`.
- pgvector requires one-time manual setup if the app DB role lacks the
  `CREATE EXTENSION` grant.

**Migration path**
1. Deploy. Migration enables pgvector and creates `domain_classifications`.
2. Run `rake recommendation:backfill` once.
3. Run `rake recommendation:classify_unclassified` manually for first LLM pass.
4. Schedule the two cron jobs in k8s.
5. Optionally drop `auctions.classification_*` columns after a release of
   stable v2 operation.

## References

- `docs/architecture/recommendation-system.md` — high-level overview, schemas,
  phase list.
- `docs/technical/domain-classification-pipeline.md` — pipeline internals,
  prompts, schema.
- `docs/guides/recommendation-operations.md` — operator runbook.
