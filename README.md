# Auction center
[![Maintainability](https://qlty.sh/gh/internetee/projects/auction_center/maintainability.svg)](https://qlty.sh/gh/internetee/projects/auction_center)
[![Code Coverage](https://qlty.sh/gh/internetee/projects/auction_center/coverage.svg)](https://qlty.sh/gh/internetee/projects/auction_center)

Software for managing TLD domain auctions

## Setup

1. Run `bin/setup`
2. Configure database in `config/database.yml` according to your needs
3. Adjust configuration variables in `config/customization.yml`.
4. Run `bundle exec rake db:setup`

## Default user account

By default, the application creates an administrator user account that should be used only to create new user accounts, and then deleted.

```
email: administrator@auction.test
password: password
```

## API

System provides auction API endpoint & self-health check API endpoint.

### Auction API
Auction center exposes list of current auctions as JSON api. Time reported in `ends_at` and `starts_at` are always in UTC.

```
Request:
GET /auctions HTTP/1.1
Accept: appliction/json

Response:
HTTP/1.1 200
Content-Type: application/json

[
  {
    "id": "1b3ee442-e8fe-4922-9492-8fcb9dccc69c",
    "domain_name": "auction.test",
    "starts_at": "2019-02-23T22:00:00.000Z"
    "ends_at": "2019-02-24T22:00:00.000Z"
}
]
```

### Health check API

Documentation on health check API is available at project WiKi [here](https://github.com/internetee/auction_center/wiki/Health-check-API).
## Settings

There are certain settings stored in the database that are used for the application logic. For example, the currency in which all auctions are conducted. An administrator can change these settings in /admin/settings page.

## Jobs

To send out emails and perform other asynchronous tasks, we use a background processing with PostgreSQL as queue backend. To start an executor, use `bundle exec rails jobs:work`.

Part of running the application according to EIS business rules includes creating new auctions at the beginning of the day. Jobs are scheduled outside of the application, as the exact times are no concern of the application.

## Recommendation system

The public auction list is personalised: each user sees auctions ranked by how
well every domain matches their behaviour and stated interests. Ranking is
built on a single embedding space ("magnets") — everything about a user (bids,
wishlist, views, selected categories, free-text interests) becomes a vector,
and domains are ranked by their pull towards those vectors.

### Prerequisite: feature flag

The whole system is gated by the OpenAI integration. In
`config/customization.yml`:

```yaml
openai:
  enabled: true
  access_token: 'sk-...'
```

When disabled, no classification, embedding or scoring runs and the list falls
back to the global `ai_score` / default order. A running job worker
(`bundle exec rails jobs:work`) is required for every `*_later` job below.

### What runs automatically (event-driven, no manual action)

| Trigger | Job | Effect |
|---|---|---|
| A new auction is created | `ClassifyDomainJob` (`Auction after_create`) | Classifies + embeds that domain |
| A user bids / wishlists / views a domain | `RefreshSingleUserAuctionScoresJob` (30 s debounce, via `EventTracker`) | Re-scores that one user |
| A user saves their interest profile | `RefreshSingleUserAuctionScoresJob` (debounced) | Re-scores that user |
| A user adds/edits free-text ("other") interests | `EmbedCustomInterestsJob` | Embeds the new interests, then re-scores |
| An admin adds/renames an interest category | `EnrichInterestCategoriesJob` | Generates description + keywords + embedding for that category |

In normal operation this is all that happens — the system keeps itself current
as auctions, bids and profiles change.

### What runs on a schedule (cron)

Batched catch-up jobs for domains that were created in bulk or whose LLM
classification has gone stale (6-month refresh). Schedule these like the other
cron jobs (outside the app):

```bash
bundle exec rake recommendation:classify_unclassified   # ClassifyUnclassifiedDomainsJob (batched)
bundle exec rake recommendation:embed_unembedded        # EmbedUnembeddedDomainsJob (batched)
```

### What you run manually

**After every deploy** (and after first enabling the feature) run the full
pipeline once. It is incremental (`force: false`): it enriches interest
categories, backfills embeddings for existing users' custom interests,
classifies + embeds any domains still missing it, refreshes the global
`ai_score`, and recomputes every participant's personal scores. Work that is
already done is **not** redone.

```bash
bundle exec rake recommendation:init
```

Other manual entry points:

| Command / action | When to use |
|---|---|
| `rake recommendation:init` | After a deploy, or after first turning the feature on |
| `rake recommendation:init_demo` | Staging/test only — seeds mock active auctions + signals, then runs the pipeline |
| `rake recommendation:backfill` | One-shot heuristic classification of historical domains (the LLM refines them later) |
| `rake recommendation:compare_versions` | Dev tool — prints the current ranking side by side for inspection (`LIMIT=`, `USER_ID=`) |
| `Recommendation::RebuildRecommendationsJob` on **/admin/jobs** | Full re-tag of **every** domain (`force: true`). Run after the interest-category catalog changes (add/rename/delete), so domains are re-classified under the new vocabulary |

### Where to see the results (admin)

- **/admin/interest_categories** — each category shows its AI status
  (enriched / pending); the edit page shows the generated description,
  keywords and embedding details.
- **/admin/auctions/:id** — the auction detail page shows the domain's full LLM
  classification (category, tags, keywords, audience, languages, brandability,
  confidence, embedding status).

### Experimental: tags on the public list

`auction_tags_display_enabled` in `config/customization.yml` (default `false`)
swaps the "auction type" column on the public auction list for the domain's
LLM-derived tags. A missing key is treated as `false`.

## Audits

Due to various regulatory requirements, all database tables are audited according to the following procedure:

1. Changes in `public.users` table are recorded into audit.users. Audit records `action` `old_value`, `new_value`, `recorded_at` time according to postgres time zone and `object_id` which corresponds to the primary key of data in `users`.
2. History of each object is visible in the UI for the administrator.
3. Audit data is never deleted, even if the original object is. For example, if you destroy user with id `123`, it's history can still be accessed under `/admin/users/123/versions`.

### Adding new database table to audits

1. Create a migration similar to [AuditUsersTable](db/migrate/20180921084531_audit_users_table.rb)
2. Create a new audit model like [Audit::User](app/models/audit/user.rb).
   Make sure to set self.table_name to `audit.your_table`
3. Add auditable concern to administrator routes:
   ```ruby
   namespace :admin, constraints: Constraints::Administrator.new do
     resources posts, concerns: [:auditable]
   end
   ```
