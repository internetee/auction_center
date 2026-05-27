require 'test_helper'

class OpenaiStructuredOutputSupportTest < ActiveSupport::TestCase
  def test_returns_configured_model_when_it_supports_structured_output
    assert_equal 'gpt-4o-mini', OpenaiStructuredOutputSupport.model('gpt-4o-mini')
    assert_equal 'gpt-4.1', OpenaiStructuredOutputSupport.model('gpt-4.1')
    assert_equal 'gpt-5', OpenaiStructuredOutputSupport.model('gpt-5')
  end

  def test_falls_back_when_model_does_not_support_structured_output
    assert_equal 'gpt-5', OpenaiStructuredOutputSupport.model('gpt-3.5-turbo')
  end

  def test_omits_temperature_for_gpt5_family
    assert_equal({}, OpenaiStructuredOutputSupport.temperature_options('gpt-5', 0.2))
  end

  def test_keeps_temperature_for_supported_non_gpt5_models
    assert_equal({ temperature: 0.2 }, OpenaiStructuredOutputSupport.temperature_options('gpt-4o-mini', 0.2))
  end
end
