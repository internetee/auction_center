require 'application_system_test_case'

class BillingProfilesTest < ApplicationSystemTestCase

  def setup
    super

    @user = users(:participant)
    @billing_profile = billing_profiles(:private_person)
    @company_billing_profile = billing_profiles(:company)
    sign_in(@user)
  end

  def test_user_can_change_his_billing_profile
    Offer.destroy_all
    @user.reload
    @billing_profile.reload

    visit billing_profiles_path

    user_name_field = find('.o-card__title.c-account__title', match: :first)
    assert_equal @user.display_name, user_name_field.value
    assert user_name_field[:readonly]

    vap_code_field = find('#input1', match: :first)
    assert_equal @billing_profile.vat_code, vap_code_field.value.empty? ? nil : @billing_profile.vat_code
    assert vap_code_field[:readonly]

    street_field = find('#input2', match: :first)
    assert_equal @billing_profile.street, street_field.value
    assert street_field[:readonly]

    city_field = find('#input3', match: :first)
    assert_equal @billing_profile.city, city_field.value
    assert city_field[:readonly]

    postal_code_field = find('#input4', match: :first)
    assert_equal @billing_profile.postal_code, postal_code_field.value
    assert postal_code_field[:readonly]

    find("a.c-btn.c-btn--ghost.c-btn--icon[href='#{edit_billing_profile_path(@billing_profile.uuid)}']").click

    find('input[name="billing_profile[vat_code]"]').set('IE6388047V')
    find('input[name="billing_profile[street]"]').set('Paldiski mnt 4777')
    find('input[name="billing_profile[city]"]').set('Tallinn')
    find('input[name="billing_profile[postal_code]"]').set('10137')
    find('select[name="billing_profile[country_code]"]').select('Estonia')

    find('button[type="submit"]', match: :first).click
  end

  def test_user_can_delete_his_billing_profile

  end

  # def test_user_details_contains_a_link_to_billing
  #   visit user_path(@user.uuid)
  #   assert(page.has_link?('Billing', href: billing_profiles_path))
  # end

  # def test_needs_to_be_signed_in_to_create_billing_profile
  #   sign_out(@user)

  #   visit new_billing_profile_path
  #   assert(page.has_text?('You need to sign in or sign up before continuing'))
  # end

  # def test_administrator_can_only_see_their_own_billing_profiles
  #   sign_in users(:administrator)
  #   visit billing_profiles_path

  #   assert_not(page.has_link?('ACME Inc.'))
  # end

  # def test_index_contains_a_link_to_new_billing_profile
  #   visit billing_profiles_path
  #   assert(page.has_link?('New', href: new_billing_profile_path))
  # end

  # def test_billing_profiles_list_contains_links_to_profiles
  #   visit billing_profiles_path
  #   assert(page.has_link?('Joe John Participant',
  #                         href: billing_profile_path(@billing_profile.uuid)))
  # end

  # def test_a_user_can_create_billing_profile_for_a_vat_liable_company
  #   Valvat.define_singleton_method(:new) do |vat_code|
  #     Class.new do
  #       define_method(:exists?) { true }
  #     end.new
  #   end

  #   visit new_billing_profile_path
  #   fill_in_address

  #   fill_in('billing_profile[name]', with: 'ACME corporation')
  #   fill_in('billing_profile[vat_code]', with: 'IE6388047V')

  #   assert_changes('BillingProfile.count') do
  #     click_link_or_button('Submit')
  #   end

  #   assert(page.has_css?('div.notice', text: 'Billing profile successfully created!'))
  # end

  # # def test_billing_profile_vat_code_needs_to_be_unique_for_user
  # #   visit new_billing_profile_path
  # #   fill_in_address

  # #   fill_in('billing_profile[name]', with: @company_billing_profile.name)
  # #   fill_in('billing_profile[vat_code]', with: @company_billing_profile.vat_code)

  # #   assert_no_changes('BillingProfile.count') do
  # #     click_link_or_button('Submit')
  # #   end
  # #   assert(page.has_text?('Vat code: has already been taken'))
  # # end

  # def test_a_user_can_create_company_billing_profile_witout_vat_code
  #   visit new_billing_profile_path
  #   fill_in_address

  #   fill_in('billing_profile[name]', with: 'ACME corporation')

  #   assert_changes('BillingProfile.count') do
  #     click_link_or_button('Submit')
  #   end

  #   assert(@user.billing_profiles
  #               .where(name: 'ACME corporation')
  #               .where('vat_code IS NULL'))

  #   assert(page.has_css?('div.notice', text: 'Billing profile successfully created!'))
  # end

  # def test_a_user_can_create_private_billing_profile
  #   visit new_billing_profile_path
  #   fill_in_address
  #   fill_in('billing_profile[name]', with: 'Private Person')

  #   assert_changes('BillingProfile.count') do
  #     click_link_or_button('Submit')
  #   end

  #   assert(page.has_css?('div.notice', text: 'Billing profile successfully created!'))
  #   assert(BillingProfile.find_by(name: @user.display_name))
  # end

  # def test_a_user_can_edit_their_billing_profile
  #   visit billing_profile_path(@billing_profile.uuid)
  #   click_link_or_button('Edit')

  #   fill_in('billing_profile[street]', with: 'New Street 12')
  #   fill_in('billing_profile[name]', with: 'Joe John Participant-New')
  #   # select_from_dropdown('Poland', from: 'billing_profile[country_code]')
  #   select 'Poland', from: 'billing_profile[country_code]'

  #   assert_no_changes('BillingProfile.count') do
  #     click_link_or_button('Submit')
  #   end

  #   assert(page.has_css?('div.notice', text: 'Billing profile successfully updated!'))
  #   assert(BillingProfile.find_by(street: 'New Street 12', name: 'Joe John Participant-New',
  #                                 country_code: 'PL'))
  # end

  # def test_edit_form_contains_existing_values
  #   visit edit_billing_profile_path(@billing_profile.uuid)

  #   country_code_field = page.find_field('billing_profile[country_code]', visible: false)
  #   assert_equal(@billing_profile.country_code, country_code_field.value)
  # end

  # def test_a_user_can_delete_their_unused_billing_profile
  #   billing_profile = billing_profiles(:unused)
  #   visit billing_profile_path(billing_profile.uuid)

  #   accept_confirm do
  #     click_link_or_button('Delete')
  #   end

  #   assert_text('Billing profile successfully deleted!')
  # end

  # def test_user_cannot_create_billing_profiles_in_the_name_of_other_user
  #   other_user = users(:second_place_participant)

  #   visit new_billing_profile_path
  #   fill_in_address
  #   fill_in('billing_profile[name]', with: 'Private Person')
  #   page.evaluate_script("document.getElementById('billing_profile_user_id').value = '#{other_user.id}'")

  #   click_link_or_button('Submit')
  #   assert(page.has_css?('div.alert', text: 'You are not authorized to access this page'))
  # end

  # def fill_in_address
  #   fill_in('billing_profile[street]', with: 'Baker Street 221B')
  #   fill_in('billing_profile[city]', with: 'London')
  #   fill_in('billing_profile[postal_code]', with: 'NW1 6XE')
  #   # select_from_dropdown('United Kingdom', from: 'billing_profile[country_code]')
  #   select 'United Kingdom', from: 'billing_profile[country_code]'
  # end
end
