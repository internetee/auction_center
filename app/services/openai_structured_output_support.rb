module OpenaiStructuredOutputSupport
  DEFAULT_MODEL = 'gpt-5'.freeze
  SUPPORTED_MODEL_PREFIXES = ['gpt-4o', 'gpt-4.1', 'gpt-5'].freeze
  CUSTOM_TEMPERATURE_UNSUPPORTED_PREFIXES = ['gpt-5'].freeze

  class << self
    def model(configured_model)
      normalized_model = configured_model.to_s.strip
      return DEFAULT_MODEL if normalized_model.blank?
      return normalized_model if supported?(normalized_model)

      Rails.logger.warn(
        "OpenAI model #{normalized_model.inspect} does not support json_schema structured outputs. " \
        "Falling back to #{DEFAULT_MODEL.inspect}."
      )
      DEFAULT_MODEL
    end

    def supported?(model_name)
      SUPPORTED_MODEL_PREFIXES.any? { |prefix| model_name.start_with?(prefix) }
    end

    def temperature_options(model_name, temperature)
      return {} if temperature.nil?
      return {} if custom_temperature_unsupported?(model_name)

      { temperature: temperature }
    end

    def custom_temperature_unsupported?(model_name)
      CUSTOM_TEMPERATURE_UNSUPPORTED_PREFIXES.any? { |prefix| model_name.start_with?(prefix) }
    end
  end
end
