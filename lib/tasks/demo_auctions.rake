namespace :demo do
  # Domain seed list grouped by intended category. After `rake demo:create_blind_auctions`
  # the Auction.after_create callback enqueues ClassifyDomainHeuristicallyJob for
  # every domain. The heuristic Tier 0 classifier will tag most of these
  # immediately from the dictionary. The nightly LLM cron then enriches keywords,
  # audience, languages and use cases. Use the variety here to verify that
  # different InterestCatalog categories surface correctly in /auctions sort.
  DEMO_DOMAINS = {
    # Estonian common nouns — dictionary should hit on first pass.
    local_service: %w[
      kohvik.ee kohv.ee ehitus.ee remont.ee parandus.ee
      ilusalong.ee kosmeetika.ee spa.ee
      restoran.ee pubi.ee baar.ee
      kingsepp.ee juuksur.ee maaler.ee elekter.ee
    ],
    health: %w[
      apteek.ee arst.ee tervis.ee hambaarst.ee
      doctor.ee clinic.ee medic.ee pharma.ee
      wellnesshub.ee fitness.ee yoga.ee
      psyhholoog.ee labor.ee
    ],
    shop_brand: %w[
      pood.ee aiapood.ee kalapood.ee raamatupood.ee mobiilipood.ee
      veebipood.ee tooriistad.ee lilled.ee mood.ee
      shopline.ee dealzone.ee foodmarket.ee
      megastore.ee bigshop.ee smartmart.ee outletshop.ee
    ],
    saas: %w[
      saasplatvorm.ee tarkvara.ee pilv.ee
      cloudstack.ee pixelcraft.ee gamesuite.ee workzone.ee startupdesk.ee
      apptools.ee devkit.ee codeflow.ee dataforge.ee
      crmstack.ee apilayer.ee testlab.ee
    ],
    b2b_service: %w[
      turundus.ee nouv.ee konsultatsioon.ee
      growthhub.ee marketflow.ee mediateam.ee accountflow.ee
      adagency.ee leadgen.ee salesforce-tools.ee
      brandstrategy.ee b2bpro.ee enterprisepro.ee
    ],
    finance: %w[
      laen.ee pank.ee raha.ee investeering.ee
      fintechlab.ee fastloan.ee cashflow.ee
      crypto-trade.ee invest24.ee bankhub.ee
      kredit.ee finance-pro.ee
    ],
    legal: %w[
      jurist.ee oigusabi.ee notar.ee
      legalhub.ee lawfirm.ee legaltech.ee
      contractpro.ee compliance-pro.ee
    ],
    education: %w[
      haridus.ee kool.ee koolitus.ee opetaja.ee
      academy.ee learnhub.ee coursestack.ee skillsup.ee
      classmate.ee studyflow.ee
    ],
    travel: %w[
      reisid.ee matk.ee majutus.ee turism.ee
      traveldesk.ee tripflow.ee hotelhub.ee
      flightbooker.ee adventurelab.ee resort-deal.ee
    ],
    automotive: %w[
      autod.ee auto.ee rent.ee
      carshop.ee motorflow.ee driveforge.ee
      autopro.ee auto-rent.ee tireshop.ee
    ],
    real_estate: %w[
      kinnisvara.ee maja.ee korter.ee
      propertylab.ee homehunt.ee realtypro.ee
      apartment-finder.ee rentdesk.ee
    ],
    media_content: %w[
      meedia.ee uudised.ee ajakiri.ee
      newsdesk.ee blogforge.ee podcastlab.ee
      videohub.ee press-room.ee
    ],
    brandable: %w[
      brandforge.ee zylo.ee zenix.ee
      koral.ee veylo.ee xolo.ee
      qarra.ee jovi.ee plooma.ee
    ],
    numeric: %w[
      24.ee 365.ee 100.ee 12345.ee
      numeric24.ee 7eleven.ee top10.ee
      shop42.ee deal99.ee
    ],
    other: %w[
      a-b-c.ee my-shop-online.ee long-domain-name-test.ee
      short.ee mid-tier.ee
    ]
  }.freeze

  desc 'Create temporary blind .ee auctions for recommendation testing (~140 domains)'
  task create_blind_auctions: :environment do
    starts_at = Time.zone.now + 1.second
    ends_at = Time.zone.now + 1.month

    domains = DEMO_DOMAINS.values.flatten.uniq

    created = 0
    skipped = 0

    domains.each do |domain_name|
      if Auction.where(domain_name: domain_name).where('ends_at > ?', Time.zone.now).exists?
        skipped += 1
        next
      end

      Auction.create!(
        domain_name: domain_name,
        starts_at: starts_at,
        ends_at: ends_at
      )

      created += 1
    end

    puts "Created #{created} blind auctions, skipped #{skipped} existing active auctions."
    puts "Total demo domains: #{domains.size} across #{DEMO_DOMAINS.size} categories."
  end

  desc 'Create varied auctions ending at different times (next hour, day, week, month)'
  task create_varied_auctions: :environment do
    now = Time.zone.now
    horizons = {
      next_hour: { ends_in: 1.hour, sample_size: 5 },
      next_day: { ends_in: 1.day, sample_size: 10 },
      next_week: { ends_in: 1.week, sample_size: 20 },
      next_month: { ends_in: 1.month, sample_size: 40 }
    }

    all_domains = DEMO_DOMAINS.values.flatten.uniq.shuffle

    created = 0
    offset = 0

    horizons.each do |_label, opts|
      batch = all_domains[offset, opts[:sample_size]] || []
      offset += opts[:sample_size]

      batch.each do |domain_name|
        bucket_domain = "varied-#{domain_name}"
        next if Auction.where(domain_name: bucket_domain).where('ends_at > ?', now).exists?

        Auction.create!(
          domain_name: bucket_domain,
          starts_at: now + 1.second,
          ends_at: now + opts[:ends_in]
        )
        created += 1
      end
    end

    puts "Created #{created} varied-horizon auctions."
  end

  desc 'Seed a participant user with wishlist + bid signals so recommendations have data to chew on'
  task seed_user_signals: :environment do
    user = User.where('? = ANY (roles)', User::PARTICIPANT_ROLE).first
    if user.nil?
      puts 'No participant user found. Create one via the UI first, then re-run.'
      next
    end

    profile = user.recommendation_profile || user.build_recommendation_profile
    profile.interest_keywords = %w[saas b2b_service custom:cloud custom:agency]
    profile.preferred_length_min = 5
    profile.preferred_length_max = 18
    profile.allow_numbers = false
    profile.allow_hyphens = false
    profile.save!
    profile.mark_completed!

    wishlist_picks = %w[cloudstack.ee fintechlab.ee marketflow.ee growthhub.ee]
    wishlist_picks.each do |domain|
      next if user.wishlist_items.exists?(domain_name: domain)

      WishlistItem.create!(user: user, domain_name: domain, cents: 5000)
    end

    bid_picks = %w[
      apteek.ee kohvik.ee jurist.ee reisid.ee
    ]
    bid_picks.each do |domain|
      auction = Auction.where(domain_name: domain).where('ends_at > ?', Time.zone.now).first
      next if auction.nil?
      next if Offer.exists?(user_id: user.id, auction_id: auction.id)

      Offer.create!(user: user, auction: auction, cents: 1500, billing_profile_id: 0)
    end

    Recommendation::RefreshSingleUserAuctionScoresJob.enqueue_debounced(user.id)

    puts "Seeded signals on user ##{user.id} (#{user.email}):"
    puts "  profile interests: #{profile.interest_categories.inspect} + custom #{profile.custom_interests.inspect}"
    puts "  wishlist:          #{wishlist_picks.inspect}"
    puts "  bids on existing:  #{bid_picks.inspect}"
    puts
    puts 'Score refresh enqueued. After the delayed_job runs (~30s), visit /auctions while signed in as this user.'
  end
end
