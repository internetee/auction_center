require 'test_helper'

class AdminAuctionsControllerTest < ActionDispatch::IntegrationTest
  AUCTION_COUNT = 'Auction.count'

  include Devise::Test::IntegrationHelpers
  include ActiveSupport::Testing::TimeHelpers

  def setup
    @administrator = users(:administrator)
  end

  def test_index_lists_upcoming_auctions
    travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone do
      sign_in @administrator
      get admin_auctions_path

      assert_response :ok
    end
  end

  def test_show_renders_ok
    auction = auctions(:valid_without_offers)

    sign_in @administrator
    User.stub(:search_deposit_participants, User.none) do
      get admin_auction_path(auction.id)
    end

    assert_response :ok
  end

  def test_destroy_deletes_auction_when_not_started
    auction = auctions(:english_nil_starts)

    sign_in @administrator
    assert_difference(AUCTION_COUNT, -1) do
      delete admin_auction_path(auction.id)
    end

    assert_redirected_to admin_auctions_path
    assert_not_nil flash[:notice]
  end

  def test_destroy_does_not_delete_auction_when_in_progress
    auction = auctions(:expired)

    sign_in @administrator
    assert_no_difference(AUCTION_COUNT) do
      delete admin_auction_path(auction.id)
    end

    assert_redirected_to admin_auctions_path
    assert_not_nil flash[:notice]
  end

  def test_create_creates_auction_and_redirects
    sign_in @administrator

    travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone do
      assert_difference(AUCTION_COUNT, 1) do
        post admin_auctions_path, params: {
          auction: {
            domain_name: 'integration-create-coverage.test',
            starts_at: Time.zone.parse('2010-07-06 10:30 +0000'),
            ends_at: Time.zone.parse('2010-07-07 10:30 +0000')
          }
        }
      end
    end

    assert_response :redirect
  end

  def test_bulk_starts_at_redirects_with_alert_when_enable_and_disable_together
    sign_in @administrator

    post bulk_starts_at_admin_auctions_path, params: {
      auction_elements: {
        enable_deposit: 'true',
        disable_deposit: 'true'
      }
    }

    assert_redirected_to admin_auctions_path
    assert_equal 'it cannot be enable and disable deposit in same action', flash[:alert]
  end

  def test_bulk_starts_at_redirects_when_service_applies_values
    sign_in @administrator

    AdminBulkActionService.stub(:apply_for_english_auction, [[], []]) do
      post bulk_starts_at_admin_auctions_path, params: {
        auction_elements: {
          enable_deposit: 'false',
          disable_deposit: 'false'
        }
      }
    end

    assert_redirected_to admin_auctions_path
    assert_not_nil flash[:notice]
  end

  def test_apply_auction_participants_creates_participation_and_redirects
    sign_in @administrator
    auction = auctions(:english)
    user = users(:participant)

    assert_difference('DomainParticipateAuction.count', 1) do
      post apply_auction_participants_admin_auctions_path, params: {
        auction_uuid: auction.uuid,
        user_ids: [user.id]
      }
    end

    assert_redirected_to admin_auction_path(auction)
  end

  def test_create_failure_returns_unprocessable_entity_as_json
    sign_in @administrator
    assert_no_difference(AUCTION_COUNT) do
      post admin_auctions_path,
           params: { auction: { domain_name: '' } },
           as: :json
    end
    assert_response :unprocessable_entity
    assert_includes response.body, "domain_name"
  end
end
