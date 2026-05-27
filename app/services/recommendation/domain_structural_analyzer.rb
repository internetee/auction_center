module Recommendation
  class DomainStructuralAnalyzer
    TLD_PATTERN = /\.[a-z]+\z/i.freeze

    class << self
      def call(domain_name)
        new(domain_name).call
      end
    end

    def initialize(domain_name)
      @domain_name = domain_name.to_s.strip.downcase
    end

    def call
      {
        domain_name: @domain_name,
        bare_name: bare_name,
        length: bare_name.length,
        has_digits: bare_name.match?(/\d/),
        has_hyphens: bare_name.include?('-'),
        token_count: tokens.size,
        tokens: tokens,
        dictionary_word: dictionary_word?,
        numeric_only: bare_name.match?(/\A\d+\z/)
      }
    end

    def bare_name
      @bare_name ||= @domain_name.sub(TLD_PATTERN, '')
    end

    def tokens
      @tokens ||= Recommendation::DomainDictionary.tokenize(bare_name)
    end

    def dictionary_word?
      return false if tokens.empty?
      return false if tokens.size > 2

      Recommendation::DomainDictionary.known?(bare_name) ||
        tokens.all? { |token| Recommendation::DomainDictionary.known?(token) }
    end
  end
end
