require 'application_system_test_case'

class HistoriesTest < ApplicationSystemTestCase

  # def setup
  #   super

  #   travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone

  #   @user = users(:participant)
  #   sign_in(@user)
  # end

  # def teardown
  #   super
  # end

  # test 'be able to render title of pages' do
  #   visit(histories_path)

  #   assert(page.has_text?('Finished'))
  # end

  # test 'be able to render finished auctions' do
  #   visit(histories_path)

  #   auction_expired_one = auctions(:with_invoice)
  #   auction_expired_two = auctions(:expired)

  #   assert auction_expired_one.ends_at <= Time.zone.now
  #   assert auction_expired_two.ends_at <= Time.zone.now

  #   assert(page.has_text?('with-invoice.test'))
  #   assert(page.has_text?('expired.test'))
  # end
end