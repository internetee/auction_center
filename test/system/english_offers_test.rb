require 'application_system_test_case'

class EnglishOffersTest < ApplicationSystemTestCase
  def setup
    super

    @english = auctions(:english)
    @english_nil = auctions(:english_nil_starts)

    @user = users(:participant)
    @user = users(:second_place_participant)
    @offer = offers(:high_english_offer)

    travel_to Time.parse('2010-07-05 10:31 +0000').in_time_zone
  end

  def teardown
    super

    travel_back
  end

  # def test_root_has_a_link_to_offers_page
  #   sign_in(@user)
  #   visit root_path

  #   assert(page.has_link?('My offers', href: offers_path))
  # end

  # def test_race_condition_case
  #   assert_equal(5, ActiveRecord::Base.connection.pool.size)

  #   p ">>>>>>>>>"
  #   p @offer.cents
  #   p ">>>>>>"

  #   begin
  #     concurrency_level = 4

  #     threads = Array.new(concurrency_level) do |_i|
  #       Thread.new do
  #         cents = @offer.cents
  #         @offer.update(cents: cents + 1000)

  #         p ">>>>>>>>>"
  #         p @offer.cents
  #         p ">>>>>>"
      
  #       end
  #     end

  #     threads.each(&:join)
  #   ensure
  #     ActiveRecord::Base.connection_pool.disconnect!
  #   end
  # end
end
