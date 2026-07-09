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

  # v3 shadow mode (plan phase B): eyeball the live v2 ranking next to the
  # magnet-based v3 ranking without persisting or switching anything.
  #   LIMIT=20          how many rows per user (default 20)
  #   USER_ID=123       a single user; omit to sweep participants who have scores
  #
  # Run right after `recommendation:init_demo` so (a) auctions are active and
  # (b) interest categories are enriched/embedded. v3 is scored over exactly the
  # auctions the user already has v2 scores for, so the two columns always rank
  # the same universe even if some of those auctions have since ended.
  desc 'SHADOW: compare live v2 ranking vs v3 magnet ranking side by side'
  task compare_versions: :environment do
    limit = (ENV['LIMIT'] || 20).to_i

    users =
      if ENV['USER_ID']
        User.where(id: ENV['USER_ID'].to_i)
      else
        User.where(id: UserAuctionScore.distinct.pluck(:user_id))
      end

    if users.empty?
      puts 'No users to compare (no persisted v2 scores yet — run recommendation:init_demo first).'
      next
    end

    users.find_each do |user|
      scored = UserAuctionScore
               .where(user_id: user.id)
               .joins('JOIN auctions ON auctions.id = user_auction_scores.auction_id')
               .order('user_auction_scores.score DESC')
               .pluck(Arel.sql('auctions.id'), Arel.sql('auctions.domain_name'), Arel.sql('user_auction_scores.score'))
      next if scored.empty?

      v2 = scored.first(limit).map { |_, domain, score| [domain, score] }

      # Same auction universe as v2, ranked by the v3 magnet score.
      v3 = Recommendation::MagnetScorer
           .new(user:, scope: Auction.where(id: scored.map(&:first)))
           .ranked(limit:)
           .map { |auction, score| [auction.domain_name, score] }

      puts "\n=== user ##{user.id} (#{user.email}) — top #{limit} ===".ljust(80, '=')
      puts format('%-3s  %-30s %-12s  %-30s %-12s', '#', 'v2 (live)', 'score', 'v3 (magnet)', 'score')
      puts '-' * 92
      [v2.size, v3.size].max.times do |i|
        d2, s2 = v2[i]
        d3, s3 = v3[i]
        puts format('%-3d  %-30s %-12s  %-30s %-12s',
                    i + 1,
                    d2 || '', s2 ? s2.to_f.round(3) : '',
                    d3 || '', s3 ? s3.round(3) : '')
      end
    end
  end
end
