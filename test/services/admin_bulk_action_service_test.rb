require 'test_helper'

class AdminBulkActionServiceTest < ActionDispatch::IntegrationTest
  def setup
    super

    @auction = auctions(:valid_without_offers)
    @english_auction = auctions(:english)
    @english_auction_nil = auctions(:english_nil_starts)

    travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone
  end

  def teardown
    super

    travel_back
  end

  def test_should_be_set_values_for_single_auction
    assert_nil @english_auction_nil.starts_at, nil
    assert_nil @english_auction_nil.ends_at, nil
    assert_nil @english_auction_nil.starting_price, nil
    assert_nil @english_auction_nil.min_bids_step, nil
    assert_nil @english_auction_nil.slipping_end, nil

    incoming_data = valid_incoming_data(@english_auction_nil.id)
    AdminBulkActionService.apply_for_english_auction(auction_elements: incoming_data)
    @english_auction_nil.reload

    assert_not_nil @english_auction_nil.starts_at
    assert_not_nil @english_auction_nil.ends_at
    assert_equal @english_auction_nil.starting_price, 5.0
    assert_equal @english_auction_nil.min_bids_step, 5.0
    assert_equal @english_auction_nil.slipping_end, 5
  end

  def test_should_be_set_values_for_multiple_auctions
    new_english_auction = Auction.new
    new_english_auction.domain_name = 'engl_nil.test'
    new_english_auction.platform = 'english'
    new_english_auction.save

    assert_nil @english_auction_nil.starts_at, nil
    assert_nil @english_auction_nil.ends_at, nil

    array_of_auction_ids = [@english_auction_nil.id, new_english_auction.id]

    incoming_data = valid_incoming_data(array_of_auction_ids)

    AdminBulkActionService.apply_for_english_auction(auction_elements: incoming_data)
    @english_auction_nil.reload
    new_english_auction.reload

    assert_not_nil @english_auction_nil.starts_at
    assert_not_nil @english_auction_nil.ends_at
    assert_not_nil new_english_auction.starts_at
    assert_not_nil new_english_auction.ends_at

    assert_equal new_english_auction.starting_price, 5.0
    assert_equal @english_auction_nil.min_bids_step, 5.0
    assert_equal @english_auction_nil.slipping_end, 5
  end

  def test_cannot_be_set_values_for_blind_auction
    assert @auction.starts_at.to_s.include? '2010-07-05'

    incoming_data = valid_incoming_data(@auction.id)
    AdminBulkActionService.apply_for_english_auction(auction_elements: incoming_data)
    @auction.reload

    assert @auction.starts_at.to_s.include? '2010-07-05'
  end

  def test_cannot_be_set_values_for_auction_if_it_in_game
    @english_auction.update(starts_at: @english_auction.starts_at - 1.day)
    @english_auction.reload
    assert @english_auction.starts_at.to_s.include? '2010-07-04'
    assert @english_auction.in_progress?

    incoming_data = valid_incoming_data(@english_auction.id)
    AdminBulkActionService.apply_for_english_auction(auction_elements: incoming_data)
    @english_auction.reload

    assert @english_auction.starts_at.to_s.include? '2010-07-04'
    assert @english_auction.in_progress?
  end

  def test_enable_to_set_deposit_and_disable_deposit
    starts_at = Time.zone.now + 10.seconds
    ends_at = Time.zone.now + 7.days
    payload = {
                set_starts_at: starts_at,
                set_ends_at: ends_at,
                starting_price: '5.0',
                slipping_end: '5',
                elements_id: @english_auction.id.to_s,
                deposit: 100.0,
                enable_deposit: 'true'
              }
    AdminBulkActionService.apply_for_english_auction(auction_elements: payload)
    @english_auction.reload

    assert @english_auction.enable_deposit
    assert_equal @english_auction.deposit.to_f, 100.0

    payload = {
      set_starts_at: starts_at,
      set_ends_at: ends_at,
      elements_id: [@english_auction.id.to_s],
      disable_deposit: 'true'
    }
    AdminBulkActionService.apply_for_english_auction(auction_elements: payload)
    @english_auction.reload

    refute @english_auction.enable_deposit
    assert_equal @english_auction.deposit.to_f, 0.0
  end

  def test_it_should_return_list_of_auctions_what_have_errros
    starts_at = Time.zone.now + 10.seconds
    ends_at = Time.zone.now + 7.days
    payload = {
                set_starts_at: starts_at,
                set_ends_at: ends_at,
                starting_price: '5.0',
                slipping_end: '5',
                elements_id: @english_auction.id.to_s,
                enable_deposit: 'true'
              }
    result = AdminBulkActionService.apply_for_english_auction(auction_elements: payload)[1]
    @english_auction.reload

    assert_equal result[0].name, @english_auction.domain_name
    assert_equal result[0].errors[0], "the deposit amount and the \"enable deposit\" flag must be specified together or not"
  end

  def test_it_should_return_list_of_auctions_what_are_skipped
    starts_at = Time.zone.now + 10.seconds

    payload = {
      set_starts_at: starts_at + 1.day,
      elements_id: @auction.id.to_s,
    }

    result = AdminBulkActionService.apply_for_english_auction(auction_elements: payload)[0]
    @auction.reload

    assert_equal result[0], @auction.domain_name
  end

  private

  def valid_incoming_data(auction_id)
    auction_id = auction_id.join(' ') if auction_id.kind_of?(Array)
    {
      set_starts_at: '2010-07-05',
      set_ends_at: '2010-08-05',
      starting_price: '5.0',
      slipping_end: '5',
      elements_id: auction_id.to_s,
      deposit: 0.0
    }
  end
end
