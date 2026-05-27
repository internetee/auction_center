namespace :demo do
  desc 'Create temporary blind .ee auctions for recommendation testing'
  task create_blind_auctions: :environment do
    starts_at = Time.zone.now + 1.second
    ends_at = Time.zone.now + 1.month

    domains = %w[
      aiapood.ee
      apteek.ee
      arst.ee
      autod.ee
      ehitus.ee
      eood.ee
      haridus.ee
      ilusalong.ee
      jurist.ee
      kahvel.ee
      kalapood.ee
      kinnisvara.ee
      kohvik.ee
      koolitus.ee
      kosmeetika.ee
      laen.ee
      lilled.ee
      majutus.ee
      matk.ee
      meedia.ee
      mobiilipood.ee
      mood.ee
      nouv.ee
      oigusabi.ee
      parandus.ee
      pood.ee
      raamatud.ee
      raamatupood.ee
      reisid.ee
      remont.ee
      rent.ee
      saasplatvorm.ee
      tarkvara.ee
      tervis.ee
      tooriistad.ee
      turundus.ee
      veebipood.ee
      accountflow.ee
      brandforge.ee
      carshop.ee
      cloudstack.ee
      dealzone.ee
      fintechlab.ee
      foodmarket.ee
      gamesuite.ee
      growthhub.ee
      legalhub.ee
      marketflow.ee
      marketplace.ee
      mediateam.ee
      numeric24.ee
      pixelcraft.ee
      propertylab.ee
      shopline.ee
      startupdesk.ee
      traveldesk.ee
      wellnesshub.ee
      workzone.ee
    ]

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
  end
end
