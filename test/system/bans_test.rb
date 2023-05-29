require 'application_system_test_case'

class BansTest < ApplicationSystemTestCase

  DAYS_BEFORE = 1.days.freeze
  DAYS_AFTER = 5.days.freeze
  def setup
    super

    travel_to Time.parse('2010-07-05 10:31 +0000').in_time_zone

    @expired_auction = auctions(:expired)
    @valid_auction_with_no_offers = auctions(:valid_without_offers)
    @valid_auction_with_offers = auctions(:valid_with_offers)
    @administrator = users(:administrator)
    @participant = users(:participant)
    @other_participant = users(:second_place_participant)

    @ban = Ban.create!(user: @participant,
                       domain_name: @valid_auction_with_no_offers.domain_name,
                       valid_from: Time.zone.today - DAYS_BEFORE, valid_until: Time.zone.today + DAYS_AFTER)

    invoice_n = Invoice.order(number: :desc).last.number
    stub_request(:post, "http://eis_billing_system:3000/api/v1/invoice_generator/invoice_number_generator")
      .to_return(status: 200, body: "{\"invoice_number\":\"#{invoice_n + 3}\"}", headers: {})

    stub_request(:post, "http://eis_billing_system:3000/api/v1/invoice_generator/invoice_generator")
      .to_return(status: 200, body: "{\"everypay_link\":\"http://link.test\"}", headers: {})

    stub_request(:put, "http://registry:3000/eis_billing/e_invoice_response").
      to_return(status: 200, body: "{\"invoice_number\":\"#{invoice_n + 3}\"}, {\"date\":\"#{Time.zone.now-10.minutes}\"}", headers: {})

    stub_request(:post, "http://eis_billing_system:3000/api/v1/e_invoice/e_invoice").
      to_return(status: 200, body: "", headers: {})
  end

  def teardown
    super

    travel_back
    @ban.destroy
  end

  def test_banned_user_cannot_create_offers
    sign_in(@participant)

    visit auction_path(@valid_auction_with_no_offers.uuid)
    click_link('Bid!')
    fill_in('offer[price]', with: '5.12')

    click_link_or_button('Submit')

    assert(page.has_css?('div.alert', text: I18n.t('.offers.create.ban')))
  end

  def test_banned_user_can_submit_offers_for_other_auctions
    @valid_auction_with_offers.offers.destroy_all

    sign_in(@participant)
    visit auction_path(@valid_auction_with_offers.uuid)
    click_link('Bid!')
    fill_in('offer[price]', with: '5.12')
    click_link_or_button('Submit')

    # assert(page.has_text?('Offer submitted successfully.'))
  end

  def test_banned_user_can_review_their_existing_offers
    sign_in(@participant)

    visit offers_path
    assert_not(page.has_css?('div.alert', text: 'You are not authorized to access this page'))
  end

  def test_banned_user_can_view_their_information
    sign_in(@participant)

    visit user_path(@participant.uuid)
    assert_not(page.has_css?('div.alert', text: 'You are not authorized to access this page'))

    click_link_or_button('Edit')
    assert(page.has_css?('div.alert', text: 'You are not authorized to access this page'))
  end

  def test_banned_user_cannot_delete_their_account
    sign_in(@participant)

    visit user_path(@participant.uuid)

    accept_confirm do
      click_link_or_button('Delete')
    end

    assert(page.has_css?('div.alert', text: 'You are not authorized to access this page'))
  end

  def test_banned_user_can_see_the_ban_notification_for_one_domain
    sign_in_manually

    text = <<~TEXT.squish
      You are banned from participating in auctions for domain(s): no-offers.test.
    TEXT

    visit auctions_path
    assert(page.has_css?('div.ban', text: text))
  end

  def test_banned_user_can_see_the_ban_notification_for_two_domains
    Ban.create!(user: @participant,
                domain_name: @valid_auction_with_offers.domain_name,
                valid_from: Time.zone.today - DAYS_BEFORE, valid_until: Time.zone.today + DAYS_AFTER)

    sign_in_manually

    text = <<~TEXT.squish
      You are banned from participating in auctions for
      domain(s): no-offers.test, with-offers.test.
    TEXT

    visit auctions_path
    assert(page.has_css?('div.ban', text: text))
  end

  def test_banned_user_can_see_the_ban_notification_only_for_active_auctions
    Ban.create!(user: @participant,
                domain_name: 'dummy-domain.net',
                valid_from: Time.zone.today - DAYS_BEFORE, valid_until: Time.zone.today + DAYS_AFTER)

    sign_in_manually

    expected_notification = <<~TEXT.squish
      Number of current violations: 2
    TEXT

    expected_clause = <<~TEXT.squish
      According to clause 7.3.3 of the .ee Auction Environment User Agreement a user can use the service of the environment if there are less than 3 unpaid invoices under their user account.
    TEXT

    visit auctions_path
    assert_text expected_notification
    assert_text expected_clause
  end

  def test_banned_user_can_see_the_ban_notification_for_longest_repetitive_ban
    Ban.create!(user: @participant,
                valid_from: Time.zone.today - 1, valid_until: Time.zone.today + 5)
    Ban.create!(user: @participant,
                valid_from: Time.zone.today - 1, valid_until: Time.zone.today + 2)
    sign_in_manually

    expected_notification = <<~TEXT.squish
      You are banned from participating in .ee domain auctions due to multiple overdue
      invoices until 2010-07-07.
    TEXT

    violations_notification = <<~TEXT.squish
      Number of current violations: 2 of 3
    TEXT

    visit auctions_path
    assert_text expected_notification
    assert_no_text violations_notification
  end

  def test_administrator_can_review_bans
    sign_in(@administrator)
    visit admin_bans_path

    within('tbody#bans-table-body') do
      assert(page.has_link?('Delete', href: admin_ban_path(@ban)))
    end

    accept_confirm do
      click_link_or_button('Delete')
    end

    assert(page.has_css?('div.notice', text: 'Deleted successfully.'))
  end

  def test_administrator_can_create_bans
    sign_in(@administrator)
    visit admin_user_path(@other_participant)

    fill_in('ban[valid_until]', with: '01/01/2222')
    assert_changes -> { Ban.count } do
      click_link_or_button('Submit')
    end

    assert(page.has_css?('div.notice', text: 'Created successfully.'))
  end

  def test_administrator_cannot_create_bans_that_are_valid_in_the_past
    sign_in(@administrator)
    visit admin_user_path(@other_participant)

    fill_in('ban[valid_until]', with: '01/01/1999')
    assert_no_changes -> { Ban.count } do
      click_link_or_button('Submit')
    end

    assert(page.has_css?('div.notice', text: 'Something went wrong.'))
  end

  def sign_in_manually
    visit(users_path)

    within('nav.menu-user') do
      click_link_or_button('Sign in')
    end

    fill_in('user_email', with: 'user@auction.test')
    fill_in('user_password', with: 'password123')

    within('form#new_user') do
      click_link_or_button('Sign in')
    end

    assert_text('Signed in successfully')
  end
end
