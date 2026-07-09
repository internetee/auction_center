module Recommendation
  # Thin wrapper over the OpenAI embeddings endpoint for arbitrary text.
  # Shared by the v3 category enricher and custom-interest embedding so the
  # request/response handling lives in one place. DomainEmbedder predates this
  # and keeps its own copy to avoid touching the proven domain path.
  #
  # Returns an array of 1536-float vectors aligned to the input order.
  module TextEmbedder
    MODEL = Recommendation::DomainEmbedder::MODEL

    module_function

    def embed(texts)
      inputs = Array(texts).map(&:to_s)
      return [] if inputs.empty?

      client = OpenAI::Client.new
      response = client.embeddings(parameters: { model: MODEL, input: inputs })

      error = response.dig('error', 'message')
      raise StandardError, error if error

      data = response.fetch('data')
      data.sort_by { |item| item['index'] }.map { |item| item.fetch('embedding') }
    end
  end
end
