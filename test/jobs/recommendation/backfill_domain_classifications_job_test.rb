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

      with_feature_flag(true) do
        stub_llm do
          Recommendation::BackfillDomainClassificationsJob.new.perform
        end
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

      with_feature_flag(true) do
        stub_llm do
          assert_no_difference -> { DomainClassification.where(domain_name: 'skip-me.ee').count } do
            Recommendation::BackfillDomainClassificationsJob.new.perform
          end
        end
      end
    end

    def test_no_op_when_openai_disabled
      Auction.create!(
        domain_name: 'no-llm.ee',
        starts_at: 1.hour.ago,
        ends_at: 1.day.from_now,
        skip_validation: true
      )

      with_feature_flag(false) do
        assert_no_difference -> { DomainClassification.count } do
          Recommendation::BackfillDomainClassificationsJob.new.perform
        end
      end
    end

    private

    def stub_llm
      original = Recommendation::LlmDomainClassifier.method(:call)
      Recommendation::LlmDomainClassifier.define_singleton_method(:call) do |domain_names:, **|
        Array(domain_names).map do |d|
          {
            domain_name: d.to_s.strip.downcase,
            primary_category: 'other',
            tags: ['other'],
            keywords: [],
            audience: nil,
            languages: [],
            suggested_use_cases: [],
            brandability_score: nil,
            confidence: 0.9,
            classification_source: DomainClassification::OPENAI_SOURCE,
            classification_model: 'gpt-5',
            classified_at: Time.current,
            raw_llm_response: {}
          }
        end
      end
      yield
    ensure
      Recommendation::LlmDomainClassifier.define_singleton_method(:call, original)
    end

    def with_feature_flag(enabled)
      original = Feature.method(:open_ai_integration_enabled?)
      Feature.define_singleton_method(:open_ai_integration_enabled?) { enabled }
      yield
    ensure
      Feature.define_singleton_method(:open_ai_integration_enabled?, original)
    end
  end
end
