require 'test_helper'

module Recommendation
  class ClassifyDomainJobTest < ActiveJob::TestCase
    def setup
      super
      DomainClassification.where(domain_name: 'apteek.ee').delete_all
      Setting.find_by(code: 'openai_model')&.update!(value: 'gpt-5')
    end

    def test_classifies_unknown_domain_via_llm
      stub_openai('apteek.ee', primary: 'health')

      with_feature_flag(true) do
        assert_difference -> { DomainClassification.count }, 1 do
          Recommendation::ClassifyDomainJob.new.perform('apteek.ee')
        end
      end

      row = DomainClassification.find_by(domain_name: 'apteek.ee')
      assert_equal 'health', row.primary_category
      assert_equal DomainClassification::OPENAI_SOURCE, row.classification_source
    end

    def test_no_op_when_openai_disabled
      with_feature_flag(false) do
        assert_no_difference -> { DomainClassification.count } do
          Recommendation::ClassifyDomainJob.new.perform('apteek.ee')
        end
      end
      assert_not_requested :post, 'https://api.openai.com/v1/chat/completions'
    end

    def test_skips_fresh_llm_classification
      DomainClassification.create!(domain_name: 'apteek.ee',
                                   classification_source: DomainClassification::OPENAI_SOURCE,
                                   confidence: 0.9,
                                   classified_at: 1.hour.ago)

      with_feature_flag(true) do
        assert_no_difference -> { DomainClassification.count } do
          Recommendation::ClassifyDomainJob.new.perform('apteek.ee')
        end
      end
      assert_not_requested :post, 'https://api.openai.com/v1/chat/completions'
    end

    def test_no_op_for_blank_domain
      with_feature_flag(true) do
        assert_no_difference -> { DomainClassification.count } do
          Recommendation::ClassifyDomainJob.new.perform('')
          Recommendation::ClassifyDomainJob.new.perform(nil)
          Recommendation::ClassifyDomainJob.new.perform('   ')
        end
      end
    end

    def test_auction_create_enqueues_classification
      assert_enqueued_with(job: Recommendation::ClassifyDomainJob) do
        Auction.create!(
          domain_name: "trigger-test-#{SecureRandom.hex(4)}.ee",
          starts_at: 1.hour.ago,
          ends_at: 1.day.from_now,
          skip_validation: true
        )
      end
    end

    private

    def stub_openai(domain_name, primary:)
      body = {
        'choices' => [{
          'finish_reason' => 'stop',
          'message' => {
            'content' => {
              classifications: [{
                domain_name: domain_name,
                primary_category: primary,
                tags: [primary],
                keywords: %w[example],
                audience: 'b2c',
                languages: %w[et],
                suggested_use_cases: %w[service],
                brandability_score: 0.5,
                confidence: 0.9
              }]
            }.to_json
          }
        }]
      }
      stub_request(:post, 'https://api.openai.com/v1/chat/completions')
        .to_return_json(status: 200, body: body, headers: {})
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
