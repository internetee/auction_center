require 'test_helper'

class BansIntegrationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  DAYS_BEFORE = 1.days.freeze
  DAYS_AFTER = 5.days.freeze

  def setup
    @user = users(:participant)
    @second_user = users(:second_place_participant)
    @administrator = users(:administrator)
    @valid_auction_with_no_offers = auctions(:valid_without_offers)
    @orphaned_auction = auctions(:orphaned)
    @billing_profile = billing_profiles(:private_person)

    sign_in @administrator
    @ban = Ban.create!(user: @user,
                       domain_name: @valid_auction_with_no_offers.domain_name,
                       valid_from: Time.zone.today - DAYS_BEFORE, valid_until: Time.zone.today + DAYS_AFTER)

    @second_ban = Ban.create!(user: @second_user,
                              domain_name: @orphaned_auction.domain_name,
                              valid_from: Time.zone.today - DAYS_BEFORE, valid_until: Time.zone.today + DAYS_AFTER)
  end
end
