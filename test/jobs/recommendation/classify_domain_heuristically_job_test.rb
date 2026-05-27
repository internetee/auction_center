require 'test_helper'

module Recommendation
  class ClassifyDomainHeuristicallyJobTest < ActiveJob::TestCase
    def test_creates_classification_for_unknown_domain
      DomainClassification.where(domain_name: 'apteek.ee').delete_all

      assert_difference -> { DomainClassification.count }, 1 do
        Recommendation::ClassifyDomainHeuristicallyJob.new.perform('apteek.ee')
      end
    end

    def test_idempotent_for_fresh_classification
      DomainClassification.where(domain_name: 'apteek.ee').delete_all
      Recommendation::ClassifyDomainHeuristicallyJob.new.perform('apteek.ee')

      assert_no_difference -> { DomainClassification.count } do
        Recommendation::ClassifyDomainHeuristicallyJob.new.perform('apteek.ee')
      end
    end

    def test_no_op_for_blank_domain
      assert_no_difference -> { DomainClassification.count } do
        Recommendation::ClassifyDomainHeuristicallyJob.new.perform('')
        Recommendation::ClassifyDomainHeuristicallyJob.new.perform(nil)
        Recommendation::ClassifyDomainHeuristicallyJob.new.perform('   ')
      end
    end

    def test_auction_create_enqueues_classification
      assert_enqueued_with(job: Recommendation::ClassifyDomainHeuristicallyJob) do
        Auction.create!(
          domain_name: "trigger-test-#{SecureRandom.hex(4)}.ee",
          starts_at: 1.hour.ago,
          ends_at: 1.day.from_now,
          skip_validation: true
        )
      end
    end
  end
end
