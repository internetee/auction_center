namespace :recommendation do
  # The single prod entry point. Incremental (force: false): enriches interest
  # categories, backfills users' custom-interest vectors, then drains the batched
  # classify + embed jobs (picking up any domain that is unclassified, stale, or
  # built under an older embedding-input format), refreshes ai_score, and
  # recomputes every participant's personal scores. Already-done work is skipped.
  #
  # Run on every deploy. This is also the cron catch-up: it drains the same
  # classify/embed batches a standalone cron would, so no separate cron task is
  # needed for them.
  desc 'PROD/CRON: run the whole recommendation pipeline (classify -> embed -> ai_score -> per-user scores)'
  task init: :environment do
    summary = Recommendation::PipelineRunner.run(force: false)
    puts "Recommendation pipeline done: #{summary.inspect}"
  end

  # Retention for the append-only recommendation_events table (unrelated to the
  # pipeline above; schedule daily). Deletes events >6 months old and
  # auction_impression events >1 month old, in batches.
  desc 'CRON: prune old recommendation_events (6mo; impressions 1mo)'
  task prune_events: :environment do
    deleted = Recommendation::PruneRecommendationEventsJob.perform_now
    puts "Pruned #{deleted} recommendation event(s)."
  end

  # One-shot historical seed: classify every domain we have ever seen (active +
  # ended auctions, wishlist, offer histories, results) so past-bid domains get
  # embeddings and can form magnets. init only classifies active auctions +
  # wishlist, so run this once when first enabling the feature.
  desc 'One-shot: classify all historical domains via LLM (wider universe than init)'
  task backfill: :environment do
    if defined?(Recommendation::BackfillDomainClassificationsJob)
      Recommendation::BackfillDomainClassificationsJob.perform_now
    else
      puts 'BackfillDomainClassificationsJob is not yet available. Skipping.'
    end
  end

  desc 'TEST/STAGING: create active mock auctions + signals, then run the pipeline'
  task init_demo: :environment do
    Rake::Task['demo:create_active_auctions'].invoke
    Rake::Task['demo:seed_user_signals'].invoke
    summary = Recommendation::PipelineRunner.run(force: false)
    puts "Recommendation pipeline (demo) done: #{summary.inspect}"
  end
end
