require 'test_helper'

class Admin::DomainBansIntegrationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @administrator = users(:administrator)
    @user = users(:participant)
    @auction = auctions(:valid_without_offers)

    sign_in @administrator
  end

  def test_creates_domain_ban_with_valid_params
    valid_until = Time.zone.today + 100.days

    assert_difference('Ban.count', 1) do
      post admin_bans_domain_bans_path, params: {
        ban: {
          user_id: @user.id,
          domain_name: @auction.domain_name,
          valid_until: valid_until
        }
      }
    end

    ban = Ban.last
    assert_equal @user.id, ban.user_id
    assert_equal @auction.domain_name, ban.domain_name
    assert_equal valid_until, ban.valid_until.to_date
    assert_not_nil ban.valid_from
    assert_redirected_to admin_bans_path
  end

  def test_creates_domain_ban_with_invoice_reference
    invoice = invoices(:payable)
    valid_until = Time.zone.today + 100.days

    assert_difference('Ban.count', 1) do
      post admin_bans_domain_bans_path, params: {
        ban: {
          user_id: @user.id,
          domain_name: 'example.ee',
          valid_until: valid_until,
          invoice_id: invoice.id
        }
      }
    end

    ban = Ban.last
    assert_equal invoice.id, ban.invoice_id
  end

  def test_rejects_ban_without_valid_until
    assert_no_difference('Ban.count') do
      post admin_bans_domain_bans_path, params: {
        ban: {
          user_id: @user.id,
          domain_name: 'example.ee',
          valid_until: nil
        }
      }
    end

    assert_redirected_to admin_user_path(@user.id)
  end

  def test_rejects_ban_with_past_valid_until
    assert_no_difference('Ban.count') do
      post admin_bans_domain_bans_path, params: {
        ban: {
          user_id: @user.id,
          domain_name: 'example.ee',
          valid_until: Time.zone.today - 1.day
        }
      }
    end

    assert_redirected_to admin_user_path(@user.id)
  end

  def test_rejects_ban_without_domain_name
    assert_no_difference('Ban.count') do
      post admin_bans_domain_bans_path, params: {
        ban: {
          user_id: @user.id,
          domain_name: '',
          valid_until: Time.zone.today + 30.days
        }
      }
    end

    assert_redirected_to admin_user_path(@user.id)
  end

  def test_rejects_duplicate_active_domain_ban
    Ban.create!(user: @user, domain_name: 'duplicate.ee',
                valid_from: Time.zone.now, valid_until: Time.zone.today + 50.days)

    assert_no_difference('Ban.count') do
      post admin_bans_domain_bans_path, params: {
        ban: {
          user_id: @user.id,
          domain_name: 'duplicate.ee',
          valid_until: Time.zone.today + 30.days
        }
      }
    end

    assert_redirected_to admin_user_path(@user.id)
  end

  def test_allows_domain_ban_when_existing_ban_expired
    Ban.create!(user: @user, domain_name: 'expired-ban.ee',
                valid_from: Time.zone.now - 60.days, valid_until: Time.zone.now - 1.day)

    assert_difference('Ban.count', 1) do
      post admin_bans_domain_bans_path, params: {
        ban: {
          user_id: @user.id,
          domain_name: 'expired-ban.ee',
          valid_until: Time.zone.today + 30.days
        }
      }
    end

    assert_redirected_to admin_bans_path
  end

  def test_non_administrator_cannot_create_domain_ban
    sign_out @administrator
    sign_in @user

    assert_no_difference('Ban.count') do
      post admin_bans_domain_bans_path, params: {
        ban: {
          user_id: @user.id,
          domain_name: 'example.ee',
          valid_until: Time.zone.today + 30.days
        }
      }
    end
  end
end
