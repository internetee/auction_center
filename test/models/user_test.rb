require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    super

    @administrator = users(:administrator)

    stub_request(:any, /eis_billing_system/)
      .to_return(status: 200, body: "{\"reference_number\":\"12332\"}", headers: {})
  end

  def test_required_fields
    user = User.new

    assert_not(user.valid?)
    assert_equal(["Password can't be blank"], user.errors[:password])
    assert_equal(["Email can't be blank"], user.errors[:email])
    assert_equal(["can't be blank", 'Phone number is invalid'], user.errors[:mobile_phone])
    assert_equal(['Terms and conditions must be accepted'], user.errors[:terms_and_conditions])
    assert_equal(["can't be blank"], user.errors[:given_names])
    assert_equal(["can't be blank"], user.errors[:surname])

    user.email = 'email@example.com'
    user.password = 'email@example.com'
    user.password_confirmation = 'email@example.com'
    user.surname = 'Surname'
    user.given_names = 'Given Names'
    user.mobile_phone = '+372500100300'
    user.identity_code = '51007050687'
    user.country_code = 'EE'
    user.accepts_terms_and_conditions = true

    assert(user.valid?)
  end

  def test_identity_code_can_be_empty_if_not_estonian
    user = User.new

    user.surname = 'Surname ÄÖÜÕÜÖöäüüäö O’CONNEŽ-ŠUSLIK TESTNUMBER'
    user.given_names = 'MARY ÄNN'
    user.email = 'email@example.com'
    user.password = 'email@example.com'
    user.password_confirmation = 'email@example.com'
    user.mobile_phone = '+372500100300'
    user.country_code = 'PL'
    user.accepts_terms_and_conditions = 'true'

    assert(user.valid?)
  end

  def test_identity_code_invalid_if_estonian_and_wrong
    user = User.new

    user.surname = 'Surname'
    user.given_names = 'Given Names'
    user.email = 'email@example.com'
    user.password = 'email@example.com'
    user.password_confirmation = 'email@example.com'
    user.mobile_phone = '+372500100300'
    user.country_code = 'EE'
    user.identity_code = '97812120009'
    user.accepts_terms_and_conditions = 'true'

    assert_not(user.valid?)
  end

  def test_identity_code_valid_if_estonian_and_correct
    user = User.new

    user.surname = 'Surname'
    user.given_names = 'Given Names'
    user.email = 'email@example.com'
    user.password = 'email@example.com'
    user.password_confirmation = 'email@example.com'
    user.mobile_phone = '+372500100300'
    user.country_code = 'EE'
    user.identity_code = '37812120009'
    user.accepts_terms_and_conditions = 'true'

    assert(user.valid?)
  end

  def test_does_not_accept_invalid_values
    user = User.new

    user.surname = '"><svg/onload=confirm(1)>'
    user.given_names = '-sleep(10)#'
    user.email = 'email@example.com'
    user.password = 'email@example.com'
    user.password_confirmation = 'email@example.com'
    user.mobile_phone = '+372500100300'
    user.country_code = 'PL'
    user.accepts_terms_and_conditions = 'true'

    assert_not(user.valid?)
  end

  def test_allow_to_use_chezh_name
    user = User.new

    user.surname = 'ÁdsdÉ'
    user.given_names = 'ÁdsdÉ ÁdsdÉ'
    user.email = 'email@example.com'
    user.password = 'email@example.com'
    user.password_confirmation = 'email@example.com'
    user.mobile_phone = '+372500100300'
    user.country_code = 'CZ'
    user.accepts_terms_and_conditions = 'true'

    assert(user.valid?)
  end

  def test_allow_to_use_portuguese_name
    user = User.new

    user.surname = 'Salomão'
    user.given_names = 'Rómulo'
    user.email = 'email@example.com'
    user.password = 'email@example.com'
    user.password_confirmation = 'email@example.com'
    user.mobile_phone = '+372500100300'
    user.country_code = 'PT'
    user.accepts_terms_and_conditions = 'true'

    assert(user.valid?)
  end

  def test_not_allow_to_use_russian_name
    user = User.new

    user.surname = 'Рудольф'
    user.given_names = 'Якобсон'
    user.email = 'email@example.com'
    user.password = 'email@example.com'
    user.password_confirmation = 'email@example.com'
    user.mobile_phone = '+372500100300'
    user.country_code = 'RU'
    user.accepts_terms_and_conditions = 'true'

    assert_not(user.valid?)
  end

  def test_can_be_banned
    first_ban = Ban.create(user_id: @administrator.id, valid_until: Date.tomorrow)
    Ban.create(user_id: @administrator.id, valid_until: Date.today + 3.days)
    Ban.create(user_id: @administrator.id, valid_until: Date.today + 6.days)

    assert(@administrator.banned?)
    assert_equal(first_ban, @administrator.longest_ban)

    user = User.new
    assert_not(user.banned?)
    assert_not(user.longest_ban)
  end

  def test_password_needs_a_confirmation
    @administrator.password = 'password'
    @administrator.password_confirmation = 'not matching'

    assert_not(@administrator.valid?)
    assert_equal(["doesn't match Password"], @administrator.errors[:password_confirmation])

    @administrator.password_confirmation = 'password'
    assert(@administrator.valid?)
  end

  def test_email_must_be_unique
    new_user = User.new(email: @administrator.email, password: 'password',
                        password_confirmation: 'password')

    assert_not(new_user.valid?)
    assert_equal(['has already been taken'], new_user.errors[:email])
  end

  def test_identity_code_must_be_unique_for_a_country
    new_user = User.new(identity_code: @administrator.identity_code,
                        country_code: @administrator.country_code)

    assert_not(new_user.valid?)
    assert_equal(['Identity code is already in use'], new_user.errors[:identity_code])
  end

  def test_country_code_is_an_alias
    user = User.new
    user.alpha_two_country_code = 'EE'
    assert_equal('EE', user.country_code)
  end

  def test_signed_in_with_identity_document
    user = User.new

    assert_not(user.signed_in_with_identity_document?)

    user.provider = 'github'
    assert_not(user.signed_in_with_identity_document?)

    user.provider = User::TARA_PROVIDER
    assert_not(user.signed_in_with_identity_document?)

    user.uid = 'EE1234'
    assert(user.signed_in_with_identity_document?)
  end

  def test_requires_captcha
    user = User.new

    assert(user.requires_captcha?)

    user.provider = User::TARA_PROVIDER
    user.uid = 'EE1234'

    assert_not(user.requires_captcha?)
  end

  def test_requires_phone_number_confirmation
    user = User.new
    assert_not(user.requires_phone_number_confirmation?)

    Setting.find_by(code: :require_phone_confirmation).update!(value: 'true')
    assert(user.requires_phone_number_confirmation?)

    user.mobile_phone_confirmed_at = Time.now.in_time_zone
    assert_not(user.requires_phone_number_confirmation?)

    user.mobile_phone_confirmed_at = nil
    user.provider = User::TARA_PROVIDER
    user.uid = 'EE1234'
    assert_not(user.requires_phone_number_confirmation?)
  end

  def test_phone_nr_confirmed_if_unique
    current_value = Setting.find_by(code: :require_phone_confirmation).retrieve
    Setting.find_by(code: :require_phone_confirmation).update!(value: 'true')
    _first_user = users(:participant)
    second_user = users(:second_place_participant)

    assert_not(second_user.valid?)
    Setting.find_by(code: :require_phone_confirmation).update!(value: current_value)
  end

  def test_country_code_must_be_two_letters_long
    @administrator.country_code = 'EST'
    assert_raise ActiveRecord::ValueTooLong do
      @administrator.save
    end
  end

  def test_display_name
    @administrator.given_names = 'New Given Name'
    @administrator.save

    assert_equal('New Given Name Administrator', @administrator.display_name)
  end

  def test_accepts_terms_and_conditions_are_only_updated_when_needed
    original_terms_and_conditions_accepted_at = @administrator.terms_and_conditions_accepted_at
    @administrator.update(accepts_terms_and_conditions: true)

    assert_equal(original_terms_and_conditions_accepted_at,
                 @administrator.terms_and_conditions_accepted_at)

    @administrator.update(accepts_terms_and_conditions: false)
    @administrator.update(accepts_terms_and_conditions: true)

    assert_not_equal(original_terms_and_conditions_accepted_at,
                     @administrator.terms_and_conditions_accepted_at)
  end

  def test_has_default_role
    user = User.new

    assert_equal([User::PARTICIPANT_ROLE], user.roles)
    assert(user.role?(User::PARTICIPANT_ROLE))
    assert_not(user.role?(User::ADMINISTATOR_ROLE))
  end

  def test_localized_validations_are_ignored_for_different_countries
    user = boilerplate_user

    user.mobile_phone = '+3727271000'
    user.identity_code = '05071020395'
    user.country_code = 'LV'

    assert(user.valid?)
  end

  def test_mobile_phone_needs_to_be_valid
    user = boilerplate_user

    user.mobile_phone = '+3727271000'
    assert(user.valid?)

    ['Foo', '112', '55965456', 'Foo+3727271000'].each do |number|
      user.mobile_phone = number
      assert_not(user.valid?, "Expected #{number} to be invalid")
    end
  end

  def test_user_is_participant_of_auction_if_he_made_bid
    travel_to Time.parse('2010-07-06 09:30 +0000').in_time_zone
    
    user = users(:participant)
    auction = auctions(:english)

    assert auction.in_progress?
    refute user.participated_in_english_auction?(auction)

    Offer.create!(
      auction: auction,
      user: user,
      cents: 10_000,
      billing_profile: user.billing_profiles.first
    )

    user.reload && auction.reload
    assert user.participated_in_english_auction?(auction)
  end

  def test_user_is_not_participant_of_auction_if_he_not_made_bid
    travel_to Time.parse('2010-07-06 09:30 +0000').in_time_zone

    user = users(:participant)
    user_2 = users(:second_place_participant)
    billing = billing_profiles(:company)
    auction = auctions(:english)

    refute user.participated_in_english_auction?(auction)
    assert auction.in_progress?

    Offer.create!(
      auction: auction,
      user: user_2,
      cents: 10_000,
      billing_profile: billing
    )

    user.reload
    user_2.reload
    auction.reload

    refute user.participated_in_english_auction?(auction)
    assert user_2.participated_in_english_auction?(auction)
  end

  def test_user_is_participant_of_auction_if_he_added_deposit
    travel_to Time.parse('2010-07-06 09:30 +0000').in_time_zone
    user = users(:participant)
    auction = auctions(:english)

    refute user.participated_in_english_auction?(auction)
    assert auction.in_progress?

    DomainParticipateAuction.create(
      user: user, auction: auction
    )

    user.reload && auction.reload
    refute auction.offers.any? { |offer| offer.user == user }
    assert user.participated_in_english_auction?(auction)
  end

  def test_user_is_not_participant_of_auction_if_he_not_added_deposit
    travel_to Time.parse('2010-07-06 09:30 +0000').in_time_zone
    user = users(:participant)
    user_2 = users(:second_place_participant)
    auction = auctions(:english)

    refute user.participated_in_english_auction?(auction)
    assert auction.in_progress?

    DomainParticipateAuction.create(
      user: user_2, auction: auction
    )

    user.reload && user_2.reload && auction.reload
    
    refute user.participated_in_english_auction?(auction)
    assert user_2.participated_in_english_auction?(auction)
  end

  def test_if_user_made_deposit_participant_method_not_work_for_non_english_auction
    travel_to Time.parse('2010-07-06 09:30 +0000').in_time_zone
    
    user = users(:participant)
    auction = auctions(:valid_without_offers)

    assert auction.in_progress?
    refute user.participated_in_english_auction?(auction)

    Offer.create!(
      auction: auction,
      user: user,
      cents: 10_000,
      billing_profile: user.billing_profiles.first
    )

    user.reload && auction.reload
    refute user.participated_in_english_auction?(auction)
  end

  def test_reference_number_is_assigned_to_user_when_user_is_created
    user = boilerplate_user
    user.mobile_phone = '+372500100300'
    user.country_code = 'EE'

    refute user.persisted?
    assert_nil user.reference_no

    user.save! && user.reload

    assert user.persisted?
    assert user.reference_no
  end

  # def test_reference_number_is_assigned_to_user_when_user_is_updated
  #   user = users(:participant)
  #   user.update!(reference_no: nil) && user.reload

  #   assert_nil user.reference_no
  #   user.email = 'example@email.ee'
  #   user.save && user.reload

  #   assert user.reference_no
  # end

  def test_reference_number_is_not_assigned_to_user_when_user_is_admin
    user = users(:administrator)
    assert_nil user.reference_no
    assert user.roles.include?('administrator')

    user.email = 'admin@admin.ee'
    user.save && user.reload

    assert_nil user.reference_no

  end

  def boilerplate_user
    stub_request(:any, "https://eis_billing_system:3000/api/v1/invoice_generator/reference_number_generator")
      .to_return(status: 200, body: "{\"reference_number\":\"#{rand(100000..999999)}\"}", headers: {})

    user = User.new
    user.email = 'email@example.com'
    user.password = 'email@example.com'
    user.password_confirmation = 'email@example.com'
    user.accepts_terms_and_conditions = true
    user.surname = 'Surname'
    user.given_names = 'Given Names'
    user
  end
end
