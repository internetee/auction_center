namespace :recommendation do
  desc 'Cron entry point: classify unclassified or stale domains via LLM (batched)'
  task classify_unclassified: :environment do
    Recommendation::ClassifyUnclassifiedDomainsJob.perform_now
  end

  desc 'One-shot: classify all historical domains via heuristic (LLM picks up later)'
  task backfill: :environment do
    if defined?(Recommendation::BackfillDomainClassificationsJob)
      Recommendation::BackfillDomainClassificationsJob.perform_now
    else
      puts 'BackfillDomainClassificationsJob is not yet available. Skipping.'
    end
  end
end
