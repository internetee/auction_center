require 'test_helper'

module Recommendation
  class LlmDomainClassifierTest < ActiveSupport::TestCase
    def setup
      super
      @openai_model = Setting.find_by(code: 'openai_model')
      @openai_model.update!(value: 'gpt-5')
    end

    def test_parses_structured_response_into_attribute_hashes
      stub_request(:post, 'https://api.openai.com/v1/chat/completions')
        .to_return_json(status: 200, body: ai_response_for(%w[cloudstack.ee marketflow.ee]), headers: {})

      result = Recommendation::LlmDomainClassifier.call(domain_names: %w[cloudstack.ee marketflow.ee])

      assert_equal 2, result.size

      cloud = result.find { |r| r[:domain_name] == 'cloudstack.ee' }
      assert_equal 'saas', cloud[:primary_category]
      assert_equal %w[saas b2b_service], cloud[:tags]
      assert_equal 'Cloud platform domain.', cloud[:description]
      assert_equal 'en', cloud[:description_locale]
      assert_equal 'b2b', cloud[:audience]
      assert_includes cloud[:keywords], 'cloud'
      assert_equal DomainClassification::OPENAI_SOURCE, cloud[:classification_source]
      assert cloud[:confidence] >= 0.0
      assert cloud[:confidence] <= 1.0
    end

    def test_filters_unknown_categories_from_tags
      stub_request(:post, 'https://api.openai.com/v1/chat/completions')
        .to_return_json(status: 200, body: ai_response_with_bogus_tag('cloudstack.ee'), headers: {})

      result = Recommendation::LlmDomainClassifier.call(domain_names: %w[cloudstack.ee])
      assert_equal %w[saas], result.first[:tags]
      assert_equal 'saas', result.first[:primary_category]
    end

    def test_empty_input_returns_empty_array
      result = Recommendation::LlmDomainClassifier.call(domain_names: [])
      assert_equal [], result
    end

    def test_truncates_above_batch_limit
      huge = (1..(Recommendation::LlmDomainClassifier::BATCH_LIMIT + 25)).map { |i| "x#{i}.ee" }
      classifier = Recommendation::LlmDomainClassifier.new(domain_names: huge)
      assert_equal Recommendation::LlmDomainClassifier::BATCH_LIMIT,
                   classifier.instance_variable_get(:@domain_names).size
    end

    def test_raises_on_incomplete_response
      stub_request(:post, 'https://api.openai.com/v1/chat/completions')
        .to_return_json(status: 200,
                        body: { 'choices' => [{ 'finish_reason' => 'length', 'message' => { 'content' => '{}' } }] },
                        headers: {})

      assert_raises(StandardError) do
        Recommendation::LlmDomainClassifier.call(domain_names: %w[cloudstack.ee])
      end
    end

    private

    def ai_response_for(domain_names)
      {
        'choices' => [{
          'finish_reason' => 'stop',
          'message' => {
            'content' => {
              classifications: domain_names.map { |name| classification_for(name) }
            }.to_json
          }
        }]
      }
    end

    def ai_response_with_bogus_tag(domain_name)
      {
        'choices' => [{
          'finish_reason' => 'stop',
          'message' => {
            'content' => {
              classifications: [{
                domain_name: domain_name,
                primary_category: 'not_a_real_category',
                tags: %w[saas absolutely_made_up],
                description: 'desc',
                description_locale: 'en',
                keywords: %w[cloud],
                audience: 'b2b',
                languages: %w[en],
                suggested_use_cases: %w[platform],
                brandability_score: 0.5,
                confidence: 0.9
              }]
            }.to_json
          }
        }]
      }
    end

    def classification_for(name)
      {
        domain_name: name,
        primary_category: 'saas',
        tags: %w[saas b2b_service],
        description: 'Cloud platform domain.',
        description_locale: 'en',
        keywords: %w[cloud platform],
        audience: 'b2b',
        languages: %w[en],
        suggested_use_cases: %w[platform agency],
        brandability_score: 0.75,
        confidence: 0.92
      }
    end
  end
end
