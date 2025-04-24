require 'test_helper'

class DepositStatusesTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @auction = auctions(:english)
    @user = users(:participant)
    @admin = users(:administrator)

    message = {"message": "Status updated"}
    stub_request(:post, "http://eis_billing_system:3000/api/v1/invoice_generator/deposit_status")
      .to_return(status: 200, body: message.to_json, headers: {})

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
    # Подготавливаем заглушку, которая возвращает ошибку 500
    message = {"error": "Internal Server Error"}
    stub_request(:post, "http://eis_billing_system:3000/api/v1/invoice_generator/deposit_status")
      .to_return(status: 500, body: message.to_json, headers: {})
    
    params = {
      status: 'returned'
    }
    d = DomainParticipateAuction.create(user_id: @user.id, auction_id: @auction.id)
    
    # Проверяем исходное состояние
    assert_equal 'paid', d.status
    
    # Выполняем запрос
    patch admin_paid_deposit_deposit_status_path(id: d.id), params: params
    
    # Проверяем, что статус не изменился
    d.reload
    assert_equal 'paid', d.status
    
    # Проверяем, что есть сообщение об ошибке
    assert_equal 'danger', flash[:alert_type]
    assert_match /error/i, flash[:alert]
  end
end