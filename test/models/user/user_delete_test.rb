require 'test_helper'

class UserDeleteTest < ActiveSupport::TestCase
  def setup
    super

    @user = users(:participant)
    @offer = offers(:expired_offer)
    @billing_profile = billing_profiles(:company)
    @result = results(:expired_participant)
  end

  def test_user_id_fields_are_nullified_when_user_is_deleted
    @user.destroy

    [@offer, @billing_profile, @result].each do |item|
      item.reload
      assert_nil(item.user_id, "expected #{item.class}.user_id to be nil")
      assert_nil(item.user, "expected #{item.class}.user to be nil")
    end
  end
end
