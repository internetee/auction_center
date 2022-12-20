require 'test_helper'

class AssignPlatformTest < ActiveSupport::TestCase
  test 'assign blinf type to auction what has type of nil' do
    a = auctions(:valid_with_offers)
    a.update(platform: nil)
    a.reload

    assert_nil a.platform

    run_task

    a.reload
    assert_equal a.platform, "blind"
  end

  private

  def run_task
    Rake::Task['auction:assign_platform'].execute
  end
end
