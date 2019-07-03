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
