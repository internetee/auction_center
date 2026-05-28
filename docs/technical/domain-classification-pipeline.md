# Domain Classification Pipeline — Technical Details

Companion to [recommendation-system.md](../architecture/recommendation-system.md). This document describes implementation of the classification pipeline.

## Components

```
app/services/recommendation/
  domain_classifier.rb              # orchestrator (Tier 0 only at runtime)
  domain_structural_analyzer.rb     # purely structural, no semantics
  domain_heuristic_classifier.rb    # dictionary + subword tokenizer
  domain_dictionary.rb              # ESTONIAN_ROOTS + ENGLISH_ROOTS hashes
  llm_domain_classifier.rb          # Tier 2 — only called from cron job

app/jobs/recommendation/
  classify_domain_heuristically_job.rb     # instant, triggered on events
  classify_unclassified_domains_job.rb     # cron, batched LLM
  backfill_domain_classifications_job.rb   # one-shot

lib/tasks/recommendation.rake              # entry points for k8s CronJobs
```

## Tier 0 — Heuristic classifier

### Structural analyzer

Computes deterministic structural features for any domain name. No external dependencies. Output is stable and cheap to recompute, but stored for query speed.

| feature | how |
|---|---|
| `has_digits` | `domain_name =~ /\d/` |
| `has_hyphens` | `domain_name.include?('-')` |
| `token_count` | greedy subword split + count |
| `dictionary_word` | exact match in et+en root dictionary |
| `length` | `domain_name.length` after stripping `.ee` |

### Heuristic classifier

Algorithm:

1. Strip TLD (`.ee`)
2. Greedy subword split using dictionary:
   - Try longest prefix match against `ESTONIAN_ROOTS ∪ ENGLISH_ROOTS`
   - Recurse on remainder
3. For each matched root, collect its assigned category and confidence
4. Aggregate: deduplicate categories, pick highest-confidence as `primary_category`
5. `confidence = matched_chars / total_chars` (heuristic — full dictionary match = 1.0, partial = proportional)
6. If `confidence < 0.6` → flag for LLM enrichment

### Dictionary (DomainDictionary)

Two static hashes — Estonian and English roots → category symbol.

```ruby
ESTONIAN_ROOTS = {
  'kohvik' => :local_service, 'apteek' => :health,
  'pood' => :shop_brand,      'kinnisvara' => :real_estate,
  'laen' => :finance,         'jurist' => :legal,
  # ... ~200 entries
}

ENGLISH_ROOTS = {
  'shop' => :shop_brand, 'tech' => :saas,
  'cloud' => :saas,      'med' => :health,
  # ... ~200 entries
}
```

Initial dictionary seeded from the existing `lib/tasks/demo_auctions.rake` seed list and OpenAI test classifications. Grows over time as Tier 2 reveals new patterns.

## Tier 2 — LLM enrichment (cron-only)

### Trigger

`rake recommendation:classify_unclassified` (k8s CronJob, daily 03:00).

Selects rows where:

```ruby
DomainClassification
  .where(classification_source: ['heuristic', nil])
  .or(DomainClassification.where('confidence < 0.6'))
  .or(DomainClassification.where('classification_source = ? AND classified_at < ?', 'openai', 6.months.ago))
  .limit(MAX_DOMAINS_PER_RUN)
```

### Batching

50 domains per OpenAI call. JSON schema includes every rich field.

### Schema (OpenAI structured output)

```json
{
  "name": "domain_classifications",
  "schema": {
    "type": "object",
    "properties": {
      "classifications": {
        "type": "array",
        "items": {
          "type": "object",
          "properties": {
            "domain_name":           { "type": "string" },
            "primary_category":      { "type": "string", "enum": [...InterestCatalog...] },
            "tags":                  { "type": "array", "items": { "type": "string" } },
            "description":           { "type": "string" },
            "description_locale":    { "type": "string", "enum": ["en", "et"] },
            "keywords":              { "type": "array", "items": { "type": "string" } },
            "audience":              { "type": "string", "enum": ["b2b", "b2c", "mixed", "unclear"] },
            "languages":             { "type": "array", "items": { "type": "string" } },
            "suggested_use_cases":   { "type": "array", "items": { "type": "string" } },
            "brandability_score":    { "type": "number" }
          },
          "required": ["domain_name", "primary_category", "tags", "description"]
        }
      }
    }
  }
}
```

### Idempotency

`raw_llm_response` (jsonb) keeps the parsed response. If schema changes later, we can re-parse from `raw_llm_response` without re-billing OpenAI.

## Embedding pipeline — dropped from v2

Vector embeddings were planned as `text-embedding-3-small` + pgvector
HNSW index for cosine similarity, with a per-auction multiplier on top
of the base score. This was removed before merge because pgvector would
have required either bumping the shared dev Postgres image
(`postgres:13.4` → `pgvector/pgvector:pg13`) for the whole team or
adding extension provisioning to the shared RDS — both reach beyond
auction_center's scope.

If we want vector similarity later, the recommended path is a sidecar
pgvector pod isolated to auction_center (separate StatefulSet, separate
ActiveRecord connection), leaving the main databases untouched. See
ADR-001 for the rationale.

## Triggers (instant heuristic only)

These fire `ClassifyDomainHeuristicallyJob` — NEVER call LLM directly.

| trigger | location | argument |
|---|---|---|
| `Auction` created | `after_create` callback | `auction.domain_name` |
| `WishlistItem` created | controller | `wishlist_item.domain_name` |
| `Offer` created | controller | `offer.auction.domain_name` |
| `EnglishOffer` created | controller | `english_offer.auction.domain_name` |

Job is idempotent — if a row exists with `classified_at < 1.hour.ago` from any source, skip.

## Backfill

`rake recommendation:backfill` — one-shot. Collects unique domains from:

- `Auction.distinct.pluck(:domain_name)`
- `WishlistItem.distinct.pluck(:domain_name)`
- `DomainOfferHistory.distinct.pluck(:domain_name)` (if applicable)
- `Result.distinct.pluck(:domain_name)` (via auction)

For each: run heuristic synchronously, upsert into `domain_classifications`. LLM enrichment happens on next nightly cron run.

## Migration from current state

Existing `auctions.classification_tags / primary_category / classification_source / classification_model / classified_at` columns remain populated during transition. `Scorer` reads from `domain_classifications` with fallback to `auctions.classification_*` while migration is in flight. Columns deprecated in Phase 9.

## Tests

| layer | what |
|---|---|
| `DomainStructuralAnalyzer` | unit tests on edge cases (digits, hyphens, single-char, very long) |
| `DomainHeuristicClassifier` | known et/en domains map to expected categories; ambiguous → low confidence |
| `DomainClassifier` (orchestrator) | upserts row with `source='heuristic'`; skips fresh rows |
| `LlmDomainClassifier` | mocked OpenAI; verifies prompt and parsing |
| `ClassifyUnclassifiedDomainsJob` | scope selection, batching, no LLM call when scope empty |
| `Scorer` (extended) | tag + keyword + audience + behavioural affinity paths verified |

## Operations

| signal | where to look |
|---|---|
| Daily LLM cost | OpenAI dashboard + log lines from `LlmDomainClassifier` |
| Failed classifications | `Rails.logger.warn` from `ClassifyUnclassifiedDomainsJob` |
| Backlog of unclassified | `DomainClassification.where(classification_source: ['heuristic', nil]).count` |
