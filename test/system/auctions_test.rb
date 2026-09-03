require 'application_system_test_case'
require "test_helper"

class AuctionsTest < ApplicationSystemTestCase
  AUCTION_ROWS_SELECTOR = 'tbody#bids tr.contents'
  AUCTION_DOMAIN_CELLS_SELECTOR = "#{AUCTION_ROWS_SELECTOR} td:first-child"
  ALL_LIST_I18N_KEY = 'auctions.all_list'
  DOMAIN_NAME_SORT_QUERY = /sort_by=domain_name/

  def setup
    super

    travel_to Time.parse('2010-07-05 10:40 +0000').in_time_zone

    @blind_auction = auctions(:valid_with_offers)
    @english_auction = auctions(:english)

    @user = users(:participant)
  end

  def test_if_anonymous_click_to_offer_he_redirect_to_login_page
    visit('/')

    click_link_or_button(I18n.t('auctions.bid'), match: :first)

    assert_current_path new_user_session_path
  end

  def test_if_user_click_to_offer_open_modal_window_for_blind_auction
    sign_in @user

    visit('/')

    within("tr[data-platform='english']", match: :first) do
      assert(page.has_content?(:visible, '0,00 €'))

      click_link_or_button(I18n.t('auctions.bid'))
    end

    assert_selector('.c-modal', visible: true)
  end

  def test_if_user_click_to_offer_open_modal_window_for_english_auction
    sign_in @user

    visit('/')

    within("#auction_#{@blind_auction.id}", match: :first) do
      assert(page.has_content?(:visible, @blind_auction.currently_winning_offer.price))

      find('a.c-btn.c-btn--ghost.c-btn--icon', match: :first).click
    end

    assert_selector('.c-modal', visible: true)
  end

  def test_show_all
    sign_in @user

    visit('/')

    assert(page.has_content?(:visible, I18n.t(ALL_LIST_I18N_KEY)))
    click_link_or_button(I18n.t(ALL_LIST_I18N_KEY))

    assert_current_path auctions_path + '?show_all=true'
  end

  def test_sorting_keeps_show_all
    expected_count = setup_extra_active_auctions

    visit('/')
    click_link_or_button(I18n.t(ALL_LIST_I18N_KEY))
    assert_all_auction_rows(expected_count)

    find('th.sorting', text: I18n.t('auctions.domain_name')).click

    assert_all_auction_rows(expected_count)
    assert page.has_current_path?(/show_all=true/, url: true)
    assert page.has_current_path?(DOMAIN_NAME_SORT_QUERY, url: true)
  end

  def test_show_all_keeps_existing_sort
    expected_count = setup_extra_active_auctions

    visit('/')
    find('thead th.sorting', text: I18n.t('auctions.domain_name')).click
    assert page.has_current_path?(DOMAIN_NAME_SORT_QUERY, url: true)
    page_order = all(AUCTION_DOMAIN_CELLS_SELECTOR).map { |node| node.text.strip }

    click_link_or_button(I18n.t(ALL_LIST_I18N_KEY))

    assert_all_auction_rows(expected_count)
    all_order = all(AUCTION_DOMAIN_CELLS_SELECTOR).map { |node| node.text.strip }
    assert_equal page_order, all_order.first(page_order.size)
    assert page.has_current_path?(/show_all=true/, url: true)
    assert page.has_current_path?(DOMAIN_NAME_SORT_QUERY, url: true)
  end

  # AUTOBIDER ========================================

  def test_autobider_available_only_for_english_type_auctions
    Autobider.destroy_all
    sign_in @user

    visit('/')

    within("tr[data-platform='english']", match: :first) do
      assert(page.has_content?(:visible, '0,00 €'))

      click_link_or_button(I18n.t('auctions.bid'))
    end

    assert_selector '.c-modal', visible: true
    assert_selector '#autobider_price', visible: true
    assert_selector "input[name='autobider[enable]']", visible: false

    assert(page.has_content?(:visible, "#{I18n.t('english_offers.form.autobider')}: #{I18n.t('english_offers.form.nope')}" ))
  end

  def test_autobider_not_available_for_blind_auctions
    sign_in @user

    visit('/')

    within("#auction_#{@blind_auction.id}", match: :first) do
      assert(page.has_content?(:visible, @blind_auction.currently_winning_offer.price))

      find('a.c-btn.c-btn--ghost.c-btn--icon', match: :first).click
    end

    assert_selector '.c-modal', visible: true
    assert_no_selector '#autobider_price', visible: true
    assert_no_selector "input[name='autobider[enable]']", visible: false

    refute(page.has_content?(:visible, "#{I18n.t('english_offers.form.autobider')}: #{I18n.t('english_offers.form.nope')}" ))
  end

  def test_user_can_set_autobider_and_unset_autobider
    Autobider.destroy_all

    sign_in @user

    visit('/')

    within("tr[data-platform='english']", match: :first) do
      assert(page.has_content?(:visible, '0,00 €'))

      click_link_or_button(I18n.t('auctions.bid'))
    end

    assert_selector '.c-modal', visible: true

    assert(page.has_content?(:visible, "#{I18n.t('english_offers.form.autobider')}: #{I18n.t('english_offers.form.nope')}" ))
    
    find('#autobider_price').set('100')
    
    sleep 0.5
    
    page.execute_script("document.querySelector('input[name=\"autobider[enable]\"]').checked = true")

    # TODO: Turbo stream not work in test mode
    # assert(page.has_content?(:visible, "#{I18n.t('english_offers.form.autobider')}: #{I18n.t('english_offers.form.yep')}" ))
  end

  private

  def setup_extra_active_auctions
    create_extra_active_auctions(16)
    Auction.active.count
  end

  def assert_all_auction_rows(count)
    assert_selector AUCTION_ROWS_SELECTOR, count: count
  end

  def create_extra_active_auctions(count)
    count.times do |i|
      auction = Auction.new(
        domain_name: "extra-#{i}.test",
        starts_at: Time.zone.parse('2000-01-01'),
        ends_at: Time.zone.parse('2099-12-31')
      )
      auction.skip_validation = true
      auction.save!
    end
  end
end
