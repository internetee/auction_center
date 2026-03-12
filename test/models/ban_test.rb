require 'test_helper'

class BanTest < ActiveSupport::TestCase
  def setup
    super

    @time = DateTime.parse('2010-07-05 10:31 +0000').in_time_zone
    travel_to @time

    @user = users(:participant)
    @other_user = users(:second_place_participant)
    @domain_name = 'example.test'
    @ban = Ban.create!(valid_from: Time.zone.now - 1, valid_until: Time.zone.now + 60,
                       user: @user)
  end

  def teardown
    super

    travel_back
  end

  def test_valid_scope
    assert_equal([@ban].to_set, Ban.valid.to_set)
  end

  def test_domain_name_format_validation
    ban = Ban.new(user: @user, valid_from: Time.zone.now, valid_until: Time.zone.now + 1.day)

    ban.domain_name = nil
    assert ban.valid?, 'Ban should be valid without domain_name'

    ban.domain_name = ''
    assert ban.valid?, 'Ban should be valid with blank domain_name'

    ban.domain_name = 'example.ee'
    assert ban.valid?, 'Ban should be valid with correct domain format'

    ban.domain_name = 'my-domain.test'
    assert ban.valid?, 'Ban should be valid with hyphenated domain'

    ban.domain_name = 'not a domain'
    assert_not ban.valid?, 'Ban should be invalid with spaces in domain'
    assert_includes ban.errors[:domain_name], I18n.t('activerecord.errors.models.ban.attributes.domain_name.invalid_domain_format')

    ban.domain_name = 'http://example.ee'
    assert_not ban.valid?, 'Ban should be invalid with protocol prefix'
  end

  def test_no_duplicate_active_ban_for_same_domain
    Ban.create!(user: @user, domain_name: 'unique.ee',
                valid_from: Time.zone.now, valid_until: Time.zone.now + 30.days)

    duplicate = Ban.new(user: @user, domain_name: 'unique.ee',
                        valid_from: Time.zone.now, valid_until: Time.zone.now + 10.days)
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:domain_name], I18n.t('activerecord.errors.models.ban.attributes.domain_name.already_banned')
  end

  def test_allows_ban_for_different_domain
    Ban.create!(user: @user, domain_name: 'first.ee',
                valid_from: Time.zone.now, valid_until: Time.zone.now + 30.days)

    different = Ban.new(user: @user, domain_name: 'second.ee',
                        valid_from: Time.zone.now, valid_until: Time.zone.now + 10.days)
    assert different.valid?
  end

  def test_allows_ban_without_domain_name_regardless_of_existing
    Ban.create!(user: @user, domain_name: 'any.ee',
                valid_from: Time.zone.now, valid_until: Time.zone.now + 30.days)

    general = Ban.new(user: @user, valid_from: Time.zone.now, valid_until: Time.zone.now + 10.days)
    assert general.valid?
  end

  def test_valid_until_must_be_later_than_valid_from
    ban = Ban.new(user: @user)

    ban.valid_until = Time.now.in_time_zone - 1.day
    assert_not(ban.valid?)
    assert_equal(ban.errors[:valid_until], ['must be later than valid_from'])

    ban.valid_until = Time.now.in_time_zone
    assert_not(ban.valid?)
    assert_equal(ban.errors[:valid_until], ['must be later than valid_from'])

    ban.valid_until = Time.now.in_time_zone + 1.day
    assert(ban.valid?)
  end
end
