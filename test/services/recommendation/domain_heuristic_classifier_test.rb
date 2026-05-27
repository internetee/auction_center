require 'test_helper'

module Recommendation
  class DomainHeuristicClassifierTest < ActiveSupport::TestCase
    def test_known_estonian_domain_maps_to_expected_category
      result = Recommendation::DomainHeuristicClassifier.call('kohvik.ee')
      assert_equal 'local_service', result[:primary_category]
      assert_includes result[:tags], 'local_service'
      assert_equal 1.0, result[:confidence]
      assert_includes result[:languages], 'et'
    end

    def test_compound_english_domain_maps_to_first_match
      result = Recommendation::DomainHeuristicClassifier.call('marketflow.ee')
      assert_includes result[:tags], 'shop_brand'
      assert result[:confidence] > 0.5
      assert_includes result[:languages], 'en'
    end

    def test_numeric_domain_classified_as_numeric
      result = Recommendation::DomainHeuristicClassifier.call('12345.ee')
      assert_equal 'numeric', result[:primary_category]
      assert_includes result[:tags], 'numeric'
      assert_equal 1.0, result[:confidence]
    end

    def test_unknown_domain_has_low_confidence
      result = Recommendation::DomainHeuristicClassifier.call('zxyqwerty.ee')
      assert result[:confidence] < Recommendation::DomainHeuristicClassifier::BRANDABLE_BONUS_THRESHOLD
      assert_nil result[:primary_category]
      assert_empty result[:tags]
    end

    def test_metadata_is_present
      result = Recommendation::DomainHeuristicClassifier.call('cloudstack.ee')
      assert_equal DomainClassification::HEURISTIC_SOURCE, result[:classification_source]
      assert_equal 'heuristic_v1', result[:classification_model]
      assert result[:classified_at].is_a?(Time)
    end

    def test_hyphenated_lowers_brandability
      with_hyphen = Recommendation::DomainHeuristicClassifier.call('cool-shop.ee')
      without_hyphen = Recommendation::DomainHeuristicClassifier.call('coolshop.ee')
      assert with_hyphen[:brandability_score] < without_hyphen[:brandability_score]
    end

    def test_digits_layer_in_numeric_tag
      result = Recommendation::DomainHeuristicClassifier.call('shop42.ee')
      assert_includes result[:tags], 'numeric'
      assert_includes result[:tags], 'shop_brand'
    end
  end
end
