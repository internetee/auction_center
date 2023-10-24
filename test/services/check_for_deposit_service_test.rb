require 'test_helper'

class CheckForDepositServiceTest < ActiveSupport::TestCase
  setup do
    Spy.on_instance_method(EisBilling::BaseController, :authorized).and_return(true)
    @invoice = invoices(:payable)
    @auction = auctions(:english)
    @user = users(:participant)
  end

  def test_should_allow_to_participate_in_auction_if_deposit_is_added
    @auction.update(enable_deposit: true, requirement_deposit_in_cents: 50000)
    @auction.reload

    refute @auction.allow_to_set_bid?(@user)

    EisBilling::CheckForDepositService.call(
      domain_name: @auction.domain_name,
      user_uuid: @user.uuid,
      user_email: @user.email,
      transaction_amount: 500.0,
      invoice_number: @invoice.number
    )
    @user.reload

    assert @auction.allow_to_set_bid?(@user)
  end

  def test_should_not_create_if_transaction_is_less_of_requirement_sum
    @auction.update(enable_deposit: true, requirement_deposit_in_cents: 50000)
    @auction.reload

    refute @auction.allow_to_set_bid?(@user)

    EisBilling::CheckForDepositService.call(
      domain_name: @auction.domain_name,
      user_uuid: @user.uuid,
      user_email: @user.email,
      transaction_amount: 300.0,
      invoice_number: @invoice_number
    )
    @user.reload

    refute @auction.allow_to_set_bid?(@user)
  end

  def test_should_not_create_duplicates
    @auction.update(enable_deposit: true, requirement_deposit_in_cents: 50000)
    @auction.reload

    refute @auction.allow_to_set_bid?(@user)
    refute @auction.domain_participate_auctions.where(user: @user).present?

    EisBilling::CheckForDepositService.call(
      domain_name: @auction.domain_name,
      user_uuid: @user.uuid,
      user_email: @user.email,
      transaction_amount: 500.0,
      invoice_number: @invoice.number
    )

    EisBilling::CheckForDepositService.call(
      domain_name: @auction.domain_name,
      user_uuid: @user.uuid,
      user_email: @user.email,
      transaction_amount: 500.0,
      invoice_number: @invoice.number
    )
    @user.reload && @auction.reload

    assert @auction.allow_to_set_bid?(@user)
    assert @auction.domain_participate_auctions.where(user: @user).present?

    assert_equal @auction.domain_participate_auctions.count, 1
  end
end
