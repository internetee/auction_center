require 'test_helper'

class DepositStatusesTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @auction = auctions(:english)
    @user = users(:participant)
    @admin = users(:administrator)

    sign_in @admin
  end

  def test_should_change_status_to_prepayment
    params = {
      status: 'prepayment'
    }
    d = DomainParticipateAuction.create(user_id: @user.id, auction_id: @auction.id)

    assert_equal d.status, 'paid'

    patch admin_paid_deposit_deposit_status_path(id: d.id), params: params

    d.reload
    assert_equal d.status, 'prepayment'
  end

  def test_should_change_status_to_returned
    params = {
      status: 'returned'
    }
    d = DomainParticipateAuction.create(user_id: @user.id, auction_id: @auction.id)

    assert_equal d.status, 'paid'

    patch admin_paid_deposit_deposit_status_path(id: d.id), params: params

    d.reload
    assert_equal d.status, 'returned'
  end

  def test_should_render_error_from_billing_side
    # TODO: implement
  end
end