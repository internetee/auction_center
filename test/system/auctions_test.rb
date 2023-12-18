require 'application_system_test_case'
require "test_helper"

class AuctionsTest < ApplicationSystemTestCase
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
      assert(page.has_content?(:visible, '0.0 €'))

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

  def test_subscribe_to_notifications
    sign_in @user

    visit('/')

    assert(page.has_content?(:visible, I18n.t('auctions.subscribe_for_notifications')))
    click_link_or_button(I18n.t('auctions.subscribe_for_notifications'))

    assert(page.has_content?(:visible, I18n.t('auctions.unsubscribe_for_notifications')))
  end

  def test_show_all
    sign_in @user

    visit('/')

    assert(page.has_content?(:visible, I18n.t('auctions.all_list')))
    click_link_or_button(I18n.t('auctions.all_list'))

    assert_current_path auctions_path + '?show_all=true'
  end

  def test_sort_table
    # TODO: Stimulus actions not work in test mode
    # --------------------------------------------

    # sign_in @user

    # visit('/')

    # list_of_domain = page.all('tbody#bids tr.contents td:first-child').map(&:text)

    # puts list_of_domain
    # puts '-----'

    # find('.sorting', text: I18n.t('auctions.domain_name', match: :first)).click

    # list_of_domain = page.all('tbody#bids tr.contents td:first-child').map(&:text)

    # puts list_of_domain
  end

  def test_filter_auction_list
    # TODO: Stimulus actions not work in test mode
    # --------------------------------------------

  #   sign_in @user

  #   visit('/')

  #   list_of_domain = page.all('tbody#bids tr.contents td:first-child').map(&:text)

  #   puts list_of_domain
  #   puts '-----'

  #   find('#domain_name').set('english_auction.test')
  #   sleep 1


  #   list_of_domain = page.all('tbody#bids tr.contents td:first-child').map(&:text)

  #   puts list_of_domain
  #   puts '-----'

  end

  # AUTOBIDER ========================================

  def test_autobider_available_only_for_english_type_auctions
    Autobider.destroy_all
    sign_in @user

    visit('/')

    within("tr[data-platform='english']", match: :first) do
      assert(page.has_content?(:visible, '0.0 €'))

      click_link_or_button(I18n.t('auctions.bid'))
    end

    assert_selector '.c-modal', visible: true
    assert_selector '#autobider_price', visible: true
    assert_selector "input[name='autobider[enable]']"

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
    assert_no_selector "input[name='autobider[enable]']"

    refute(page.has_content?(:visible, "#{I18n.t('english_offers.form.autobider')}: #{I18n.t('english_offers.form.nope')}" ))
  end

  def test_user_can_set_autobider_and_unset_autobider
    Autobider.destroy_all

    sign_in @user

    visit('/')

    within("tr[data-platform='english']", match: :first) do
      assert(page.has_content?(:visible, '0.0 €'))

      click_link_or_button(I18n.t('auctions.bid'))
    end

    assert_selector '.c-modal', visible: true

    assert(page.has_content?(:visible, "#{I18n.t('english_offers.form.autobider')}: #{I18n.t('english_offers.form.nope')}" ))
    
    find('#autobider_price').set('100')
    # find('.o-checkbox__slider').click
    find('#checkbox').set(true)

    # TODO: Turbo stream not work in test mode
    # assert(page.has_content?(:visible, "#{I18n.t('english_offers.form.autobider')}: #{I18n.t('english_offers.form.yep')}" ))
  end


  # def setup
  #   super

  #   travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone
  #   @auction = auctions(:valid_with_offers)
  #   @other_auction = auctions(:valid_without_offers)
  #   @expired_auction = auctions(:expired)
  #   @orphaned_auction = auctions(:orphaned)
  #   @english_auction = auctions(:english)
  #   @english_nil_auction = auctions(:english_nil_starts)
  # end

  # def teardown
  #   super

  #   travel_back
  # end

  # def test_auctions_index_contains_a_list
  #   visit('/')

  #   assert(page.has_table?('auctions-table'))
  #   assert(page.has_link?('with-offers.test', href: auction_path(@auction.uuid)))
  #   assert(page.has_link?('no-offers.test', href: auction_path(@other_auction.uuid)))
  #   assert(page.has_link?('english_auction.test', href: auction_path(@english_auction.uuid)))
  #   assert(page.has_no_link?('english_nil_auction.test', href: auction_path(@english_nil_auction.uuid)))
  # end

  # def test_numbers_have_a_span_class_in_index_list
  #   visit('/')

  #   assert(span_element = page.find('span.number-in-domain-name'))
  #   assert_equal('123', span_element.text)
  # end

  # def test_numbers_have_a_span_class_in_show_view
  #   visit(auction_path(@orphaned_auction.uuid))

  #   assert(span_element = page.find('span.number-in-domain-name'))
  #   assert_equal('123', span_element.text)
  # end

  # def test_auctions_index_contains_a_link_to_terms_and_conditions
  #   visit('/')

  #   assert(
  #     page.has_link?('auctioning process',
  #                    href: 'https://www.internet.ee/help-and-info/faq#III__ee_domain_auctions')
  #   )

  #   assert(page.has_link?('terms and conditions', href: Setting.find_by(code: 'terms_and_conditions_link').retrieve))
  # end

  # def test_auctions_index_does_not_contain_auctions_that_are_finished
  #   visit('/')

  #   assert_not(page.has_link?('expired.test'))
  # end

  # def test_show_page_for_finished_auctions_still_exists
  #   visit(auction_path(@expired_auction.uuid))
  #   assert(page.has_content?(:visible, 'This auction has finished'))
  #   assert(page.has_content?(:visible, 'expired.test'))
  # end

  # def test_show_page_contains_the_details_of_the_auction
  #   visit(auction_path(@auction.uuid))
  #   assert(page.has_content?(:visible, 'with-offers.test'))
  #   assert(page.has_content?(:visible, '2010-07-06 10:30'))
  # end
  # def test_for_english_auction_should_be_bid_button
  #   visit('/')

  #   assert(page.has_link?('english_auction.test', href: auction_path(@english_auction.uuid)))
  #   assert(page.has_link?('Bid!'))
  # end
end
