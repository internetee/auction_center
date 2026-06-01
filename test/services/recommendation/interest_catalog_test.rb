require 'test_helper'

module Recommendation
  class InterestCatalogTest < ActiveSupport::TestCase
    def test_falls_back_to_constant_when_table_empty
      InterestCategory.delete_all
      assert_equal Recommendation::InterestCatalog::FALLBACK_CATEGORIES,
                   Recommendation::InterestCatalog.categories
    end

    def test_reads_active_codes_from_db_in_position_order
      InterestCategory.delete_all
      InterestCategory.create!(code: 'beta', name_en: 'Beta', name_et: 'Beeta', position: 2)
      InterestCategory.create!(code: 'alpha', name_en: 'Alpha', name_et: 'Alfa', position: 1)
      InterestCategory.create!(code: 'hidden', name_en: 'Hidden', name_et: 'Peidetud', position: 3, active: false)

      assert_equal %w[alpha beta], Recommendation::InterestCatalog.categories
    end

    def test_label_for_returns_locale_name_from_db
      InterestCategory.delete_all
      InterestCategory.create!(code: 'health', name_en: 'Health', name_et: 'Tervis', position: 1)

      I18n.with_locale(:en) { assert_equal 'Health', Recommendation::InterestCatalog.label_for('health') }
      I18n.with_locale(:et) { assert_equal 'Tervis', Recommendation::InterestCatalog.label_for('health') }
    end

    def test_label_for_unknown_code_falls_back_to_code
      InterestCategory.delete_all
      assert_equal 'mystery', Recommendation::InterestCatalog.label_for('mystery')
    end
  end
end
