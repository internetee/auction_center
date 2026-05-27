module Recommendation
  # Tier 0 classifier: deterministic, instant, free.
  #
  # Approach:
  # 1. Run DomainStructuralAnalyzer to extract tokens and structural features.
  # 2. Map known tokens -> categories via DomainDictionary.
  # 3. Confidence = ratio of matched characters to total bare-name length,
  #    capped at 1.0. A dictionary_word match short-circuits to 1.0.
  # 4. If purely numeric -> 'numeric' category, confidence 1.0.
  # 5. Output mirrors the columns of DomainClassification so a caller can
  #    upsert directly.
  class DomainHeuristicClassifier
    BRANDABLE_BONUS_THRESHOLD = 0.7  # short, no digits, no hyphens, no dictionary match

    class << self
      def call(domain_name)
        new(domain_name).call
      end
    end

    def initialize(domain_name)
      @domain_name = domain_name.to_s.strip.downcase
      @structure = DomainStructuralAnalyzer.call(@domain_name)
    end

    def call
      tags, primary_category, matched_chars = derive_categories
      brandability = compute_brandability(matched_chars)

      {
        domain_name: @domain_name,
        primary_category: primary_category&.to_s,
        tags: tags.map(&:to_s).uniq,
        keywords: derive_keywords,
        languages: derive_languages,
        audience: nil,
        suggested_use_cases: [],
        description: nil,
        description_locale: nil,
        has_digits: @structure[:has_digits],
        has_hyphens: @structure[:has_hyphens],
        token_count: @structure[:token_count],
        dictionary_word: @structure[:dictionary_word],
        brandability_score: brandability,
        confidence: derive_confidence(matched_chars),
        classification_source: DomainClassification::HEURISTIC_SOURCE,
        classification_model: 'heuristic_v1',
        classified_at: Time.current
      }
    end

    private

    def derive_categories
      if @structure[:numeric_only]
        return [%i[numeric], :numeric, @structure[:bare_name].length]
      end

      tags = []
      matched_chars = 0

      @structure[:tokens].each do |token|
        category = DomainDictionary.lookup(token)
        next unless category

        tags << category
        matched_chars += token.length
      end

      # If we matched a category, but tokens include digits, layer in :numeric.
      tags << :numeric if @structure[:has_digits] && !tags.include?(:numeric)

      primary = tags.first
      [tags, primary, matched_chars]
    end

    def derive_keywords
      # Surface non-trivial structural tokens as keywords so the scorer
      # can do keyword-overlap matching even without LLM enrichment.
      @structure[:tokens]
        .reject { |t| t.length < DomainDictionary::MIN_TOKEN_LENGTH }
        .uniq
    end

    def derive_languages
      languages = []
      tokens = @structure[:tokens]
      languages << 'et' if tokens.any? { |t| DomainDictionary::ESTONIAN_ROOTS.key?(t) }
      languages << 'en' if tokens.any? { |t| DomainDictionary::ENGLISH_ROOTS.key?(t) }
      languages
    end

    def derive_confidence(matched_chars)
      bare_length = [@structure[:bare_name].length, 1].max
      return 1.0 if @structure[:dictionary_word]
      return 1.0 if @structure[:numeric_only]

      ratio = matched_chars.to_f / bare_length
      ratio.clamp(0.0, 1.0).round(3)
    end

    def compute_brandability(matched_chars)
      bare = @structure[:bare_name]
      return 0.0 if bare.empty?

      score = 1.0
      score -= 0.2 if @structure[:has_digits]
      score -= 0.15 if @structure[:has_hyphens]
      score -= 0.1 if bare.length > 14
      score -= 0.2 if bare.length > 20
      # If dictionary words eat the whole name, it's literal, not brandable.
      coverage = matched_chars.to_f / bare.length
      score -= 0.25 if coverage > 0.85

      score.clamp(0.0, 1.0).round(3)
    end
  end
end
