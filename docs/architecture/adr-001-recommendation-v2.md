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

### D3. No vector embeddings in v2 (reversal of earlier draft)

Earlier drafts planned `text-embedding-3-small` embeddings stored in a
`vector(1536)` column with HNSW indexing for similarity-based ranking.
This was reversed before merge.

**Why we backed out:**
- The shared dev Postgres image (`postgres:13.4` in
  `docker-images/docker-compose.yml`) is used by every service on the
  team (registry, registrar_center, billing, eeid, etc.). Switching it
  to `pgvector/pgvector:pg13` would have been a patch-version bump on
  shared infrastructure for the sake of one app.
- Production RDS does support pgvector natively, but rolling it out
  consistently across dev/staging/test/prod adds operational risk for
  marginal recommendation quality.
- Tag + keyword + behavioural affinity + time decay carries the bulk
  of recommendation quality. The embedding multiplier was a 1.0..2.0
  bonus on top — useful but not load-bearing.

**Future path** if embeddings become valuable: a sidecar pgvector pod
isolated to auction_center (separate StatefulSet in k8s, separate
ActiveRecord connection in `database.yml`). Main databases stay
untouched. This is deferred until there's a concrete user-visible
ranking problem the current signals can't solve.

**What we kept:** the `domain_classifications` table including
`description`, `keywords`, `audience` and other rich fields that
feed the scorer directly without needing vectors.

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

### D6. ~~Embedding multiplier~~ — removed, see D3.

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
- Time decay means stale interests fade automatically; recent activity weighs
  more.
- Zero infrastructure changes outside auction_center. Shared dev Postgres
  image, RDS extensions, Terraform — all untouched.

**Negative**
- Two writes per domain (heuristic, then LLM enrichment). Acceptable because
  Tier 0 produces useful tags immediately while Tier 2 enriches overnight.
- More tables to operate. Mitigated by the operator runbook in
  `docs/guides/recommendation-operations.md`.
- No vector similarity matching in v2. Mitigated by keyword overlap and
  behavioural-tag affinity, which subsume the most common similarity use
  cases at our domain volume.

**Migration path**
1. Deploy. Migrations create `domain_classifications` and add classification
   fields to auctions. No extensions, no shared infra.
2. Run `rake recommendation:backfill` once.
3. Run `rake recommendation:classify_unclassified` manually for first LLM pass.
4. Schedule one cron job in k8s (`recommendation:classify_unclassified` daily).
5. Optionally drop `auctions.classification_*` columns after a release of
   stable v2 operation.

## References

- `docs/architecture/recommendation-system.md` — high-level overview, schemas,
  phase list.
- `docs/technical/domain-classification-pipeline.md` — pipeline internals,
  prompts, schema.
- `docs/guides/recommendation-operations.md` — operator runbook.
