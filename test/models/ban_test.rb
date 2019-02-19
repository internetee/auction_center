require 'test_helper'

class BanTest < ActiveSupport::TestCase
  def setup
    super

    @time = DateTime.parse('2010-07-05 10:31 +0000')
    travel_to @time

    @user = users(:participant)
    @other_user = users(:second_place_participant)
    @domain_name = 'example.test'
    @ban = Ban.create_automatic(user: @user, domain_name: @domain_name)
  end

  def teardown
    super

    travel_back
  end

  def test_create_automatic
    assert(@ban.persisted?)
    assert_equal(@domain_name, @ban.domain_name)
    assert_equal(@time >> 3, @ban.valid_until)
  end

  def test_second_automatic_ban_is_of_the_long_kind
    ban = Ban.create_automatic(user: @user, domain_name: @domain_name)

    assert(ban.persisted?)
    assert_nil(ban.domain_name)
    assert_equal(@time >> 100, ban.valid_until)
  end

  def test_valid_scope
    assert_equal([@ban].to_set, Ban.valid.to_set)
  end

  def test_for_user_and_domain_name_scope
    other_ban = Ban.create!(user: @user, valid_until: @time >> Ban::LONG_BAN_PERIOD_IN_MONTHS)
    assert_equal([other_ban].to_set, Ban.for_user_and_domain_name(@user).to_set)
    assert_equal([@ban, other_ban].to_set, Ban.for_user_and_domain_name(@user, @domain_name).to_set)

    assert_equal([].to_set, Ban.for_user_and_domain_name(@other_user).to_set)
  end
end
