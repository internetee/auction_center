require 'test_helper'

module Recommendation
  class DomainStructuralAnalyzerTest < ActiveSupport::TestCase
    def test_detects_digits
      result = Recommendation::DomainStructuralAnalyzer.call('numeric24.ee')
      assert result[:has_digits]
    end

    def test_detects_hyphens
      result = Recommendation::DomainStructuralAnalyzer.call('my-shop.ee')
      assert result[:has_hyphens]
    end

    def test_strips_tld
      result = Recommendation::DomainStructuralAnalyzer.call('cloudstack.ee')
      assert_equal 'cloudstack', result[:bare_name]
      assert_equal 'cloudstack'.length, result[:length]
    end

    def test_dictionary_word_for_single_known_root
      result = Recommendation::DomainStructuralAnalyzer.call('kohvik.ee')
      assert result[:dictionary_word]
    end

    def test_numeric_only_domain
      result = Recommendation::DomainStructuralAnalyzer.call('12345.ee')
      assert result[:numeric_only]
      assert result[:has_digits]
    end

    def test_tokenization_of_compound_known_roots
      result = Recommendation::DomainStructuralAnalyzer.call('marketflow.ee')
      assert_includes result[:tokens], 'market'
      assert_includes result[:tokens], 'flow'
    end

    def test_unknown_token_falls_through_as_single_alphabetic_run
      result = Recommendation::DomainStructuralAnalyzer.call('zxyqwerty.ee')
      assert_equal ['zxyqwerty'], result[:tokens]
      refute result[:dictionary_word]
    end
  end
end
