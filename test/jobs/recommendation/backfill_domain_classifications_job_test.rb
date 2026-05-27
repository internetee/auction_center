require 'test_helper'

module Recommendation
  class BackfillDomainClassificationsJobTest < ActiveJob::TestCase
    def setup
      super
      DomainClassification.delete_all
    end

    def test_classifies_auction_and_wishlist_domains
      auction = Auction.create!(
        domain_name: 'backfill-auction.ee',
        starts_at: 1.hour.ago,
        ends_at: 1.day.from_now,
        skip_validation: true
      )
      WishlistItem.create!(user: users(:participant), domain_name: 'backfill-wishlist.ee', cents: 1_000)

      assert_difference -> { DomainClassification.count }, ->(count) { count >= 2 } do
        Recommendation::BackfillDomainClassificationsJob.new.perform
      end

      assert DomainClassification.exists?(domain_name: 'backfill-auction.ee')
      assert DomainClassification.exists?(domain_name: 'backfill-wishlist.ee')
      auction.destroy
    end

    def test_skips_already_classified_domains
      Auction.create!(
        domain_name: 'skip-me.ee',
        starts_at: 1.hour.ago,
        ends_at: 1.day.from_now,
        skip_validation: true
      )
      DomainClassification.create!(
        domain_name: 'skip-me.ee',
        classification_source: DomainClassification::OPENAI_SOURCE,
        confidence: 0.9,
        classified_at: 1.hour.ago
      )

      assert_no_difference -> { DomainClassification.where(domain_name: 'skip-me.ee').count } do
        Recommendation::BackfillDomainClassificationsJob.new.perform
      end
    end

    def test_continues_after_individual_failures
      Auction.create!(
        domain_name: 'good.ee',
        starts_at: 1.hour.ago,
        ends_at: 1.day.from_now,
        skip_validation: true
      )

      # Simulate a failure in classifier for one specific input
      original = Recommendation::DomainClassifier.method(:call)
      Recommendation::DomainClassifier.define_singleton_method(:call) do |name, **opts|
        raise StandardError, 'simulated' if name.to_s.include?('good')

        original.call(name, **opts)
      end

      assert_nothing_raised do
        Recommendation::BackfillDomainClassificationsJob.new.perform
      end
    ensure
      if original
        Recommendation::DomainClassifier.define_singleton_method(:call) do |name, **opts|
          original.call(name, **opts)
        end
      end
    end
  end
end
