require 'test_helper'

class InvoicesPaginationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  ISSUED_INVOICE_ROWS = 'turbo-frame#outstanding_issued_invoices table > tr'
  ISSUED_PAGE_LINK = 'turbo-frame#outstanding_issued_invoices a[href*="issued_page=2"]'
  PAID_INVOICE_ROWS = 'turbo-frame#paid_invoices table > tr'
  PAID_PAGE_LINK = 'turbo-frame#paid_invoices a[href*="paid_page=2"]'
  ISSUED_FRAME = 'turbo-frame#outstanding_issued_invoices'
  CANCELLED_PAYABLE_FRAME = 'turbo-frame#outstanding_cancelled_payable'
  CANCELLED_EXPIRED_FRAME = 'turbo-frame#outstanding_cancelled_expired'
  PAID_FRAME = 'turbo-frame#paid_invoices'
  DEPOSIT_FRAME = 'turbo-frame#paid_deposits'

  setup do
    @user = users(:participant)
    @billing_profile = billing_profiles(:company)
    sign_in @user
  end

  def test_index_paginates_issued_invoices_to_ten_per_page
    create_issued_invoices(10)

    get invoices_path

    assert_response :success
    assert_select ISSUED_INVOICE_ROWS, 10
    assert_select ISSUED_PAGE_LINK
  end

  def test_issued_page_two_shows_remaining_invoices
    create_issued_invoices(10)

    get invoices_path(issued_page: 2)

    assert_response :success
    assert_select ISSUED_INVOICE_ROWS, 1
    assert_match(/with-invoice\.test/, response.body)
  end

  def test_paid_invoices_are_paginated_independently
    create_issued_invoices(10)
    create_paid_invoices(11)

    get invoices_path(issued_page: 2, paid_page: 1)

    assert_response :success
    assert_select ISSUED_INVOICE_ROWS, 1
    assert_select PAID_INVOICE_ROWS, 10
    assert_select PAID_PAGE_LINK
  end

  def test_index_includes_turbo_frames_for_each_invoice_tab
    get invoices_path

    assert_response :success
    assert_select ISSUED_FRAME
    assert_select CANCELLED_PAYABLE_FRAME
    assert_select CANCELLED_EXPIRED_FRAME
    assert_select PAID_FRAME
    assert_select DEPOSIT_FRAME
  end

  private

  def create_issued_invoices(count)
    with_invoice_numbers do
      count.times do |i|
        create_invoice(
          domain_name: "pagy-issued-#{i}.test",
          status: Invoice.statuses[:issued],
          due_date: Time.zone.today + i.days
        )
      end
    end
  end

  def create_paid_invoices(count)
    with_invoice_numbers do
      count.times do |i|
        create_invoice(
          domain_name: "pagy-paid-#{i}.test",
          status: Invoice.statuses[:paid],
          due_date: Time.zone.today + i.days,
          paid_at: Time.zone.now
        )
      end
    end
  end

  def create_invoice(domain_name:, status:, due_date:, paid_at: nil)
    auction = Auction.new(
      domain_name: domain_name,
      starts_at: 2.days.ago,
      ends_at: 1.day.ago,
      skip_validation: true
    )
    auction.save!(validate: false)

    result = Result.create!(
      auction: auction,
      user: @user,
      status: Result.statuses[:awaiting_payment],
      registration_due_date: Time.zone.today + 14.days
    )

    attrs = {
      result: result,
      user: @user,
      billing_profile: @billing_profile,
      cents: 1000,
      recipient: @billing_profile.name,
      street: @billing_profile.street,
      city: @billing_profile.city,
      postal_code: @billing_profile.postal_code,
      alpha_two_country_code: @billing_profile.country_code,
      billing_name: @billing_profile.name,
      billing_address: "#{@billing_profile.street}, #{@billing_profile.postal_code} #{@billing_profile.city}",
      billing_alpha_two_country_code: @billing_profile.country_code,
      status: status,
      issue_date: Time.zone.today,
      due_date: due_date,
      vat_rate: 0.0
    }
    attrs[:paid_at] = paid_at if paid_at

    Invoice.create!(attrs)
  end

  def with_invoice_numbers
    next_number = [Invoice.maximum(:number).to_i, 90_000].max
    response = lambda do
      next_number += 1
      Struct.new(:result?, :instance, :errors).new(true, { 'invoice_number' => next_number }, {})
    end

    EisBilling::GetInvoiceNumber.stub(:call, response) { yield }
  end
end
