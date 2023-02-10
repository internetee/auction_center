require 'application_system_test_case'

class AutobiderControllerTest < ApplicationSystemTestCase
  def setup
    super

    @participant = users(:participant)
    @auction = auctions(:english)

    travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone
    sign_in(@participant)
  end
end
