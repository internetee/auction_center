namespace :recommendation do
  desc 'Cron entry point: classify unclassified or stale domains via LLM (batched)'
  task classify_unclassified: :environment do
    Recommendation::ClassifyUnclassifiedDomainsJob.perform_now
  end

  desc 'Cron entry point: embed classified-but-unembedded domains via OpenAI (batched)'
  task embed_unembedded: :environment do
    Recommendation::EmbedUnembeddedDomainsJob.perform_now
  end

  desc 'One-shot: classify all historical domains via heuristic (LLM picks up later)'
  task backfill: :environment do
    if defined?(Recommendation::BackfillDomainClassificationsJob)
      Recommendation::BackfillDomainClassificationsJob.perform_now
    else
      puts 'BackfillDomainClassificationsJob is not yet available. Skipping.'
    end
  end

  desc 'PROD: run the whole recommendation pipeline (classify -> embed -> ai_score -> per-user scores)'
  task init: :environment do
    summary = Recommendation::PipelineRunner.run(force: false)
    puts "Recommendation pipeline done: #{summary.inspect}"
  end

  desc 'TEST/STAGING: create active mock auctions + signals, then run the pipeline'
  task init_demo: :environment do
    Rake::Task['demo:create_active_auctions'].invoke
    Rake::Task['demo:seed_user_signals'].invoke
    summary = Recommendation::PipelineRunner.run(force: false)
    puts "Recommendation pipeline (demo) done: #{summary.inspect}"
  end
end
