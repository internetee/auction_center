# Recommendation System — Operations Guide

Operator-facing guide for running the v2 recommendation system in
production. For architecture, see
[architecture/recommendation-system.md](../architecture/recommendation-system.md);
for pipeline internals, see
[technical/domain-classification-pipeline.md](../technical/domain-classification-pipeline.md).

## Environment prerequisites

| Item | Where | Notes |
|---|---|---|
| pgvector extension enabled | AWS RDS Postgres 17 | `CREATE EXTENSION IF NOT EXISTS vector;` as `rds_superuser` once per environment. The Rails migration tries this automatically; if the app role lacks `CREATE`, run it manually then run `rails db:migrate`. |
| `Feature.open_ai_integration_enabled?` | App settings | Must be true for LLM enrichment and embeddings. The recommendation profile UI, heuristic classifier, and scorer work without it. |
| `openai_model` Setting | DB seed | Currently `gpt-5`. `OpenaiStructuredOutputSupport` will fall back to a safe default if a non-supporting model is configured. |
| OpenAI API key | Rails credentials / env | Existing integration used by both `LlmDomainClassifier` and `DomainEmbedder`. |

## Kubernetes cron schedule

All recurring work runs as k8s `CronJob` resources defined in
`Ry_AWS_IaC/infrastructure/kubernetes`. Suggested schedule (UTC):

| schedule | command | purpose |
|---|---|---|
| `0 3 * * *` | `bundle exec rake recommendation:classify_unclassified` | Tier 2 LLM enrichment of heuristic / low-conf / stale rows |
| `30 3 * * *` | `bundle exec rake recommendation:embed_unembedded` | Generate OpenAI embeddings for classified-but-unembedded rows |
| one-shot | `bundle exec rake recommendation:backfill` | Initial heuristic classification of all historical domains |

Each task is wrapped by an idempotent ActiveJob. Re-running mid-day
is safe: nothing duplicates, fresh rows are skipped.

## First-time rollout checklist

1. Deploy the branch.
2. Run migrations (`rails db:migrate`). If pgvector enable_extension
   fails for permission reasons, run `CREATE EXTENSION vector` as
   `rds_superuser`, then re-run `db:migrate`.
3. Run `rake recommendation:backfill`. Watch the log line
   `BackfillDomainClassificationsJob created N classifications` to
   confirm scope.
4. (Optional, recommended) Manually run
   `rake recommendation:classify_unclassified` once to perform the
   first LLM enrichment immediately rather than waiting for cron.
5. (Optional) Manually run `rake recommendation:embed_unembedded` for
   the first embedding sweep.
6. Verify `/auctions` renders descriptions on cards with classified
   domains.

## Monitoring

| signal | check |
|---|---|
| LLM enrichment progress | `DomainClassification.needs_llm_enrichment.count` should trend toward zero. Tail logs for `ClassifyUnclassifiedDomainsJob processed N domains`. |
| Embedding backlog | `DomainClassification.needs_embedding.count` ditto. |
| Daily OpenAI cost | OpenAI dashboard. At steady state expect ~$0.01/day for classification and ~$0.0001/day for embeddings. |
| Score freshness | `UserAuctionScore.maximum(:calculated_at)` should be within minutes for active users. |
| Tracking failures | `Rails.logger.warn` lines from `EventTracker`. |

## Tunables

These constants live in `app/services/recommendation/scorer.rb`. Bumping
them requires a deploy — no DB migration needed.

| constant | default | meaning |
|---|---|---|
| `SCORING_HORIZON` | 30 days | Auctions ending later than this are not scored. |
| `HALF_LIFE_DAYS` | 60 | Behavioural signal decay half-life. |
| `WISHLIST_HIT` | 120 | Bonus if exact-match wishlist domain is up for auction. |
| `TAG_WEIGHT` / `KEYWORD_WEIGHT` | 35 / 15 | Per-interest-match boost. |
| `BID_AFFINITY_*` / `WISHLIST_AFFINITY_*` / `VIEW_AFFINITY_*` | 8/24, 6/18, 4/12 | Weight + cap for behavioural affinity. |
| `RESULT_LOST_BONUS` / `RESULT_WON_PENALTY` | +25 / -5 | Outcome signals. |

## Rolling back

To pause the system without removing it:

1. Set `Feature.open_ai_integration_enabled?` to false. LLM and
   embedding jobs become no-ops; heuristic-only continues.
2. Drop the k8s CronJobs.
3. The legacy sort still works because `Auction::UserSortable` falls
   back through `user_auction_scores` → interest match → ai_score → random.

To roll back entirely:

1. `rails db:rollback STEP=2` removes pgvector columns and the
   classifications table.
2. Revert Phase 6 commit; scorer reverts to v1 baseline.

## Troubleshooting

**"extension vector is not allowlisted"** — On RDS, run
`SHOW rds.extensions;` to confirm `vector` is present. It is on
Postgres 15+ by default. If absent, contact AWS support — but Postgres
17 always has it.

**"permission denied to create extension"** — App user lacks
`rds_superuser`. Run the `CREATE EXTENSION` manually as the master
user once per environment, then mark the migration as up with
`rails db:migrate:up VERSION=20260527090100`.

**Description shows in wrong language** — `description_locale` is
chosen by the LLM at classification time. If you want a different
locale, re-run classification with `force: true` after updating the
system prompt, or seed manual rows with `classification_source='manual'`.

**Score never updates after action** — Check whether
`RefreshSingleUserAuctionScoresJob` is reaching the worker (delayed
job table). The debounce window is 30 seconds; updates are not
real-time. Re-enqueue manually via the admin Job UI if needed.
