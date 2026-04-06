require 'test_helper'

class PaymentOrdersControllerTest < ActionController::TestCase
  tests PaymentOrdersController
  include Devise::Test::ControllerHelpers

  def setup
    super
    @routes = ActionDispatch::Routing::RouteSet.new
    @routes.draw do
      resources :invoices, only: [], param: :uuid do
        resources :payment_orders, only: %i[create], param: :uuid
      end

      resources :payment_orders, only: %i[show create], param: :uuid do
        member do
          get :return
          post :callback
        end
      end
    end
    @controller.define_singleton_method(:return_payment_order_url) { |uuid| "http://example.test/payment_orders/#{uuid}/return" }
    @controller.define_singleton_method(:callback_payment_order_url) { |uuid| "http://example.test/payment_orders/#{uuid}/callback" }
    @request.env['devise.mapping'] = Devise.mappings[:user]

    @user = users(:participant)
    sign_in @user, scope: :user

    @invoice = invoices(:payable)
    @issued_payment_order = payment_orders(:issued)
  end

  def with_authorization
    @controller.stub(:authorize!, true) { yield }
  end

  def test_create_redirects_to_show_when_successful
    params = {
      payment_order: {
        user_id: @user.id,
        invoice_id: @invoice.id,
        invoice_ids: @invoice.id.to_s,
        type: 'PaymentOrders::EveryPay'
      }
    }

    with_authorization do
      assert_difference -> { PaymentOrder.count }, 1 do
        post :create, params: params.merge(invoice_uuid: @invoice.uuid)
      end
    end

    created = PaymentOrder.order(created_at: :desc).first
    assert_equal [@invoice.id], created.invoices.pluck(:id)
    assert_redirected_to payment_order_path(created.uuid)
  end

  def test_create_returns_unprocessable_entity_for_json_when_invoice_is_already_paid
    @invoice.update_columns(status: 'paid', paid_at: Time.current)

    params = {
      payment_order: {
        user_id: @user.id,
        invoice_id: @invoice.id,
        invoice_ids: @invoice.id.to_s,
        type: 'PaymentOrders::EveryPay'
      },
      format: :json
    }

    with_authorization do
      post :create, params: params.merge(invoice_uuid: @invoice.uuid)
    end

    assert_response :unprocessable_entity
    assert response.body.present?
    assert_includes response.body, 'paid'
  end

  def test_show_sets_return_and_callback_urls
    payment_order = @issued_payment_order
    payment_order.define_singleton_method(:form_url) { 'http://example.test/form' }
    payment_order.define_singleton_method(:form_fields) { {} }

    PaymentOrder.stub(:find_by!, payment_order) do
      with_authorization do
        get :show, params: { uuid: @issued_payment_order.uuid }
      end
    end

    assert_response :ok
    assert_match %r{/payment_orders/#{@issued_payment_order.uuid}/return\z}, payment_order.return_url
    assert_match %r{/payment_orders/#{@issued_payment_order.uuid}/callback\z}, payment_order.callback_url
  end

  def test_create_binds_multiple_invoices_from_invoice_ids
    response_double = Struct.new(:result?, :instance, :errors).new(true, { 'invoice_number' => 91_111 }, {})
    second_invoice = nil

    EisBilling::GetInvoiceNumber.stub(:call, response_double) do
      second_invoice = Invoice.create!(
        result: results(:with_invoice),
        user: @user,
        billing_profile: billing_profiles(:company),
        cents: 1000,
        recipient: 'Second Invoice',
        street: 'Street',
        city: 'City',
        postal_code: '00000',
        alpha_two_country_code: 'GB',
        status: 'issued',
        issue_date: Time.zone.today,
        due_date: Time.zone.today + 7.days
      )
    end

    params = {
      payment_order: {
        user_id: @user.id,
        invoice_id: @invoice.id,
        invoice_ids: [@invoice.id, second_invoice.id].join(','),
        type: 'PaymentOrders::EveryPay'
      }
    }

    with_authorization do
      assert_difference -> { PaymentOrder.count }, 1 do
        post :create, params: params.merge(invoice_uuid: @invoice.uuid)
      end
    end

    created = PaymentOrder.order(created_at: :desc).first
    assert_equal [@invoice.id, second_invoice.id].sort, created.invoices.pluck(:id).sort
  end

  def test_create_returns_unprocessable_entity_for_json_when_any_invoice_is_already_paid
    response_double = Struct.new(:result?, :instance, :errors).new(true, { 'invoice_number' => 93_333 }, {})
    paid_invoice = nil

    EisBilling::GetInvoiceNumber.stub(:call, response_double) do
      paid_invoice = Invoice.create!(
        result: results(:with_invoice),
        user: @user,
        billing_profile: billing_profiles(:company),
        cents: 1000,
        recipient: 'Paid Invoice',
        street: 'Street',
        city: 'City',
        postal_code: '00000',
        alpha_two_country_code: 'GB',
        status: 'paid',
        issue_date: Time.zone.today,
        due_date: Time.zone.today + 7.days,
        paid_at: Time.zone.now
      )
    end

    params = {
      payment_order: {
        user_id: @user.id,
        invoice_id: @invoice.id,
        invoice_ids: [@invoice.id, paid_invoice.id].join(','),
        type: 'PaymentOrders::EveryPay'
      },
      format: :json
    }

    with_authorization do
      post :create, params: params.merge(invoice_uuid: @invoice.uuid)
    end

    assert_response :unprocessable_entity
    assert response.body.present?
    assert_includes response.body, 'paid'
  end
end
