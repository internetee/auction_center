require 'test_helper'

class InvoicesIntegrationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:participant)
    @user_two = users(:second_place_participant)
    @auction = auctions(:valid_without_offers)
    @invoice = invoices(:payable)
    @user.reload
    sign_in @user

    travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone
  end

  def test_pay_deposit
    message = {
      oneoff_redirect_link: 'http://oneoff.redirect',
    }
    stub_request(:post, 'http://eis_billing_system:3000/api/v1/invoice_generator/deposit_prepayment')
      .to_return(status: 200, body: message.to_json, headers: {})

    post english_offer_deposit_auction_path(uuid: @auction.uuid), params: nil,
                                                                  headers: {}

    assert_redirected_to 'http://oneoff.redirect'
  end

  def test_banned_user_cannot_pay_deposit
    valid_from = Time.zone.now
    Ban.create!(user: @user,
                domain_name: @auction.domain_name,
                valid_from: valid_from, valid_until: valid_from + 3.days)

    @user.reload
    assert @user.banned?

    post english_offer_deposit_auction_path(uuid: @auction.uuid,
                                            current_user: @user), params: nil, headers: {}

    assert_equal I18n.t('unauthorized.banned.message'), flash[:alert].to_s
  end

  def test_completely_banned_user_cannot_pay_any_deposit
    valid_from = Time.zone.now
    3.times do
      Ban.create!(user: @user,
                  domain_name: Faker::Internet.domain_name,
                  valid_from: Time.zone.now, valid_until: valid_from + 3.days)
    end
    @user.reload
    assert @user.completely_banned?

    post english_offer_deposit_auction_path(uuid: @auction.uuid,
                                            current_user: @user), params: nil, headers: {}

    assert_equal I18n.t('unauthorized.banned.message'), flash[:alert].to_s
  end

  def test_should_send_e_invoice
    body = {
      message: 'Invoice data received',
    }
    stub_request(:post, 'http://eis_billing_system:3000/api/v1/e_invoice/e_invoice')
      .to_return(status: :created, body: body.to_json, headers: {})

    post send_e_invoice_path(uuid: @invoice.uuid), params: nil, headers: {}

    assert_redirected_to invoice_path(@invoice.uuid)
    assert_equal 'E-Invoice was successfully sent', flash[:notice]
  end

  def test_send_e_invoice_with_billing_system_error
    body = {
      error: 'Internal server error',
    }
    stub_request(:post, 'http://eis_billing_system:3000/api/v1/e_invoice/e_invoice')
      .to_return(status: 500, body: body.to_json, headers: {})

    post send_e_invoice_path(uuid: @invoice.uuid), params: nil, headers: {}

    assert_redirected_to invoice_path(@invoice.uuid)
    assert_equal body[:error], flash[:alert]
  end

  def test_oneoff_redirects_to_oneoff_link_when_service_succeeds
    response_double = Struct.new(:result?, :instance, :errors).new(true, { 'oneoff_redirect_link' => 'http://oneoff.redirect' }, {})

    EisBilling::OneoffService.stub(:call, response_double) do
      post oneoff_invoice_path(@invoice.uuid), params: { amount: '1.0' }
    end

    assert_redirected_to 'http://oneoff.redirect'
  end

  def test_oneoff_sets_flash_and_redirects_to_invoices_when_service_fails
    response_double = Struct.new(:result?, :instance, :errors).new(false, {}, { 'message' => 'oneoff failed' })

    EisBilling::OneoffService.stub(:call, response_double) do
      post oneoff_invoice_path(@invoice.uuid), params: { amount: '1.0' }
    end

    assert_redirected_to invoices_path
    assert_equal 'oneoff failed', flash[:alert]
  end

  def test_oneoff_redirects_back_when_amount_is_not_positive
    EisBilling::OneoffService.stub(:call, ->(*) { raise 'should not be called' }) do
      post oneoff_invoice_path(@invoice.uuid), params: { amount: '0' }
    end

    assert_redirected_to invoice_path(@invoice.uuid)
    assert_equal I18n.t('invoices.amount_must_be_positive'), flash[:alert]
  end

  def test_oneoff_redirects_back_when_amount_is_too_big
    EisBilling::OneoffService.stub(:call, ->(*) { raise 'should not be called' }) do
      post oneoff_invoice_path(@invoice.uuid), params: { amount: '999999' }
    end

    assert_redirected_to invoice_path(@invoice.uuid)
    assert_equal I18n.t('invoices.amount_is_too_big'), flash[:alert]
  end

  def test_update_redirects_to_invoices_when_payable_and_update_succeeds
    response_double = Struct.new(:result?).new(true)

    EisBilling::UpdateInvoiceDataService.stub(:call, response_double) do
      patch invoice_path(@invoice.uuid), params: { invoice: { billing_profile_id: @invoice.billing_profile_id } }
    end

    assert_redirected_to invoices_path
  end

  def test_update_redirects_with_alert_when_invoice_is_already_paid
    @invoice.update_columns(status: 'paid', paid_at: Time.current)

    patch invoice_path(@invoice.uuid), params: { invoice: { billing_profile_id: @invoice.billing_profile_id } }

    assert_response :see_other
    assert_redirected_to invoices_path
    assert_equal I18n.t('invoices.invoice_already_paid'), flash[:alert]
  end

  def test_update_returns_turbo_stream_toast_when_invoice_is_already_paid
    @invoice.update_columns(status: 'paid', paid_at: Time.current)

    patch invoice_path(@invoice.uuid),
          params: { invoice: { billing_profile_id: @invoice.billing_profile_id } },
          headers: { 'Accept' => 'text/vnd.turbo-stream.html' }

    assert_response :ok
    assert_match(/turbo-stream/, response.headers['Content-Type'])
  end

  def test_download_serves_pdf_without_wkhtmltopdf
    kit_double = Object.new
    kit_double.define_singleton_method(:to_pdf) { '%PDF-1.4 dummy' }

    PDFKit.stub(:new, kit_double) do
      get download_invoice_path(@invoice.uuid)
    end

    assert_response :ok
    assert_includes response.headers['Content-Disposition'].to_s, 'attachment'
    assert_includes response.headers['Content-Disposition'].to_s, '.pdf'
    assert response.body.start_with?('%PDF-1.4')
  end

  def test_show_returns_internal_server_error_for_other_users_invoice
    sign_in @user_two

    get invoice_path(@invoice.uuid)
    assert_response :internal_server_error
  end

  def test_oneoff_returns_internal_server_error_for_other_users_invoice
    sign_in @user_two

    post oneoff_invoice_path(@invoice.uuid), params: { amount: '1.0' }
    assert_response :internal_server_error
  end

  def test_update_redirects_to_invoices_for_other_users_invoice
    sign_in @user_two

    patch invoice_path(@invoice.uuid), params: { invoice: { billing_profile_id: @invoice.billing_profile_id } }
    assert_includes [302, 500], response.status
    assert_redirected_to invoices_path if response.redirect?
  end

  def test_index_shows_only_current_users_invoices
    other_user = users(:signed_in_with_omniauth)

    EisBilling::GetInvoiceNumber.stub(:call, Struct.new(:result?, :instance, :errors).new(true, { 'invoice_number' => 94_444 }, {})) do
      Invoice.create!(
        result: results(:with_invoice),
        user: other_user,
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

    get invoices_path
    assert_response :ok
    assert_includes response.body, @invoice.result.auction.domain_name
    refute_includes response.body, 'Other User Invoice'
  end
end
