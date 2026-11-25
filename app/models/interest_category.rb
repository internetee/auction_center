class InterestCategory < ApplicationRecord
  # Initial vocabulary, also mirrored in Recommendation::InterestCatalog::FALLBACK_CATEGORIES.
  # Seeded via .seed_defaults! from both db/seeds.rb (fresh setup) and a data
  # migration (existing environments). Idempotent — never clobbers admin edits.
  DEFAULTS = [
    { code: 'brandable',     name_en: 'Brandable names',                 name_et: 'Bränditavad nimed' },
    { code: 'shop_brand',    name_en: 'Shop or store names',             name_et: 'Poe- või kaubamärgi nimed' },
    { code: 'saas',          name_en: 'SaaS and software',               name_et: 'SaaS ja tarkvara' },
    { code: 'b2b_service',   name_en: 'B2B services',                    name_et: 'B2B teenused' },
    { code: 'local_service', name_en: 'Local or service businesses',     name_et: 'Kohalikud ja teenusettevõtted' },
    { code: 'media_content', name_en: 'Media and content',              name_et: 'Meedia ja sisu' },
    { code: 'finance',       name_en: 'Finance and fintech',             name_et: 'Finants ja fintech' },
    { code: 'legal',         name_en: 'Legal and professional services', name_et: 'Õigus- ja professionaalsed teenused' },
    { code: 'health',        name_en: 'Health and wellness',             name_et: 'Tervis ja heaolu' },
    { code: 'education',     name_en: 'Education and courses',           name_et: 'Haridus ja kursused' },
    { code: 'travel',        name_en: 'Travel and tourism',              name_et: 'Reisimine ja turism' },
    { code: 'automotive',    name_en: 'Automotive',                      name_et: 'Autondus' },
    { code: 'real_estate',   name_en: 'Real estate',                     name_et: 'Kinnisvara' },
    { code: 'numeric',       name_en: 'Numeric domains',                 name_et: 'Numbrilised domeenid' },
    { code: 'other',         name_en: 'Other',                           name_et: 'Muu' }
  ].freeze

  def self.seed_defaults!
    DEFAULTS.each_with_index do |attrs, index|
      find_or_create_by(code: attrs[:code]) do |category|
        category.name_en = attrs[:name_en]
        category.name_et = attrs[:name_et]
        category.position = index + 1
        category.active = true
      end
    end
  end

  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :name_en, presence: true
  validates :name_et, presence: true
  validates :position, numericality: { only_integer: true }

  before_validation :normalize_code
  after_save_commit :enqueue_enrichment, if: :should_enrich?
  after_destroy_commit :purge_code_references

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:position, :code) }

  # v3: a category carries its own embedding (built from name + LLM keywords),
  # so a selected category acts as a magnet in the unified scorer.
  def embedded? = respond_to?(:embedding) && embedding.present?

  # Locale-aware display name. Falls back to the English name.
  def name
    I18n.locale.to_s == 'et' ? name_et.presence || name_en : name_en
  end

  private

  def normalize_code
    self.code = code.to_s.strip.downcase.presence
  end

  # Re-enrich only when the semantic content changed (name) or a vector is still
  # missing — never on unrelated saves (position, active toggle). Enrichment
  # itself uses update_columns (skips callbacks), so this never loops.
  def should_enrich?
    return false unless self.class.column_names.include?('embedding')
    return false unless Feature.open_ai_integration_enabled?
    return false unless active?

    saved_change_to_name_en? || saved_change_to_name_et? || embedding.blank?
  end

  def enqueue_enrichment
    Recommendation::EnrichInterestCategoriesJob.perform_later(id)
  end

  # There are no FKs — user profiles and domain classifications reference a
  # category only by its string code. When a category is deleted, strip that
  # orphaned code so it stops lingering as garbage (in profiles it would
  # otherwise silently degrade into a custom substring interest; on domains it
  # would remain an unmatchable tag). Cheap set-based updates, no LLM calls.
  def purge_code_references
    return if code.blank?

    RecommendationProfile
      .where('? = ANY (interest_keywords)', code)
      .update_all(['interest_keywords = array_remove(interest_keywords, ?)', code])

    if DomainClassification.column_names.include?('tags')
      DomainClassification
        .where('? = ANY (tags)', code)
        .update_all(['tags = array_remove(tags, ?)', code])
    end

    DomainClassification
      .where(primary_category: code)
      .update_all(primary_category: nil)
  end
end
