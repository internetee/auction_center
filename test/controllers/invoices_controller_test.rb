require 'test_helper'

class InvoicesControllerTest < ActionController::TestCase
  tests InvoicesController
  include Devise::Test::ControllerHelpers

  def setup
    super
    @routes = ActionDispatch::Routing::RouteSet.new
    @routes.draw do
      get '/invoices', to: 'invoices#index'
    end

    @request.env['devise.mapping'] = Devise.mappings[:user]
    @user = users(:participant)
    sign_in @user, scope: :user

    @result = results(:with_invoice)
    @billing_profile = billing_profiles(:company)

    EisBilling::GetInvoiceNumber.stub(:call, Struct.new(:result?, :instance, :errors).new(true, { 'invoice_number' => 90_000 }, {})) do
      @issued_invoice = invoices(:payable)

      @paid_invoice = Invoice.create!(
        result: @result,
        user: @user,
        billing_profile: @billing_profile,
        cents: 1000,
        recipient: 'Paid Recipient',
        street: 'Street',
        city: 'City',
        postal_code: '00000',
        alpha_two_country_code: 'GB',
        status: 'paid',
        issue_date: Time.zone.today,
        due_date: Time.zone.today + 7.days,
        paid_at: Time.zone.now
      )

      @cancelled_with_ban = Invoice.create!(
        result: @result,
        user: @user,
        billing_profile: @billing_profile,
        cents: 1000,
        recipient: 'Cancelled With Ban',
        street: 'Street',
        city: 'City',
        postal_code: '00000',
        alpha_two_country_code: 'GB',
        status: 'cancelled',
        issue_date: Time.zone.today,
        due_date: Time.zone.today + 7.days
      )

      @cancelled_without_ban = Invoice.create!(
        result: @result,
        user: @user,
        billing_profile: @billing_profile,
        cents: 1000,
        recipient: 'Cancelled Without Ban',
        street: 'Street',
        city: 'City',
        postal_code: '00000',
        alpha_two_country_code: 'GB',
        status: 'cancelled',
        issue_date: Time.zone.today,
        due_date: Time.zone.today + 7.days
      )

      @other_user_invoice = Invoice.create!(
        result: @result,
        user: users(:signed_in_with_omniauth),
        billing_profile: billing_profiles(:omniauth_company),
        cents: 1000,
        recipient: 'Other User Invoice',
        street: 'Street',
        city: 'City',
        postal_code: '00000',
        alpha_two_country_code: 'GB',
        status: 'issued',
        issue_date: Time.zone.today,
        due_date: Time.zone.today + 7.days
      )
    end

    Ban.create!(
      user: @user,
      invoice: @cancelled_with_ban,
      domain_name: 'example.test',
      valid_from: 1.day.ago,
      valid_until: 1.day.from_now
    )
  end

  def test_index_splits_invoices_by_status_and_filters_by_current_user
    @controller.stub(:authorize!, true) do
      get :index
    end

    assert_response :ok

    issued = @controller.instance_variable_get(:@issued_invoices)
    cancelled_payable = @controller.instance_variable_get(:@cancelled_payable_invoices)
    cancelled_expired = @controller.instance_variable_get(:@cancelled_expired_invoices)
    paid = @controller.instance_variable_get(:@paid_invoices)

    assert_includes issued.pluck(:id), @issued_invoice.id
    assert_includes paid.pluck(:id), @paid_invoice.id

    assert_equal [@cancelled_with_ban.id], cancelled_payable.pluck(:id)
    assert_equal [@cancelled_without_ban.id], cancelled_expired.pluck(:id)

    refute_includes issued.pluck(:id), @other_user_invoice.id
    refute_includes paid.pluck(:id), @other_user_invoice.id
    refute_includes cancelled_payable.pluck(:id), @other_user_invoice.id
    refute_includes cancelled_expired.pluck(:id), @other_user_invoice.id
  end
end
