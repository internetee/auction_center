require 'test_helper'

class AdminInterestCategoriesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @admin = users(:administrator)
    @participant = users(:participant)
    @category = InterestCategory.create!(code: 'saas', name_en: 'SaaS', name_et: 'SaaS', position: 1)
  end

  def test_index_renders_for_admin
    sign_in @admin
    get admin_interest_categories_path
    assert_response :ok
    assert_includes response.body, 'saas'
  end

  def test_new_renders_for_admin
    sign_in @admin
    get new_admin_interest_category_path
    assert_response :ok
  end

  def test_create_adds_category
    sign_in @admin

    assert_difference -> { InterestCategory.count }, 1 do
      post admin_interest_categories_path, params: {
        interest_category: { code: 'Finance', name_en: 'Finance', name_et: 'Finants', position: 2, active: true }
      }
    end

    assert_redirected_to admin_interest_categories_path
    assert InterestCategory.exists?(code: 'finance'), 'code should be normalized to lowercase'
  end

  def test_update_edits_category
    sign_in @admin

    patch admin_interest_category_path(@category), params: {
      interest_category: { name_en: 'Software', name_et: 'Tarkvara' }
    }

    assert_redirected_to admin_interest_categories_path
    assert_equal 'Software', @category.reload.name_en
  end

  def test_destroy_removes_category
    sign_in @admin

    assert_difference -> { InterestCategory.count }, -1 do
      delete admin_interest_category_path(@category)
    end
  end

  def test_create_rejects_blank_names
    sign_in @admin

    assert_no_difference -> { InterestCategory.count } do
      post admin_interest_categories_path, params: {
        interest_category: { code: 'broken', name_en: '', name_et: '' }
      }
    end

    assert_response :unprocessable_entity
  end

  def test_index_shows_enrichment_status
    sign_in @admin
    @category.update_columns(
      description: 'SaaS and software tools',
      keywords: %w[crm billing analytics],
      embedding: Array.new(3, 0.1),
      embedding_model: 'text-embedding-3-small',
      embedded_at: Time.current
    )

    get admin_interest_categories_path

    assert_response :ok
    assert_includes response.body, I18n.t('interest_categories.enriched')
  end

  def test_edit_shows_llm_enrichment_results
    sign_in @admin
    @category.update_columns(
      description: 'SaaS and software tools',
      keywords: %w[crm billing analytics],
      embedding: Array.new(3, 0.1),
      embedding_model: 'text-embedding-3-small',
      embedded_at: Time.current
    )

    get edit_admin_interest_category_path(@category)

    assert_response :ok
    assert_includes response.body, I18n.t('interest_categories.enrichment_heading')
    assert_includes response.body, 'SaaS and software tools'
    assert_includes response.body, 'crm'
  end

  def test_edit_shows_not_enriched_note_when_missing
    sign_in @admin

    get edit_admin_interest_category_path(@category)

    assert_response :ok
    assert_includes response.body, I18n.t('interest_categories.not_enriched')
  end

  def test_not_accessible_for_non_admin
    sign_in @participant
    get admin_interest_categories_path
    assert_response :not_found
  end
end
