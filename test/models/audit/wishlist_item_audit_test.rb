# require 'test_helper'

# class WishlistItemAuditTest < ActiveSupport::TestCase
#   def setup
#     super

#     travel_to Time.parse('2010-07-05 10:30 +0000').in_time_zone
#     @user = users(:participant)
#   end

#   def teardown
#     super

#     travel_back
#   end

#   def test_creating_a_wishlist_item_creates_a_history_record
#     wishlist_item = WishlistItem.new(domain_name: 'foo.bar', user: @user)
#     wishlist_item.save

#     assert(audit_record = Audit::WishlistItem.find_by(object_id: wishlist_item.id,
#                                                       action: 'INSERT'))
#     assert_equal(wishlist_item.domain_name, audit_record.new_value['domain_name'])
#   end

#   def test_deleting_a_wishlist_item_creates_a_history_record
#     wishlist_item = WishlistItem.new(domain_name: 'foo.bar', user: @user)
#     wishlist_item.save
#     wishlist_item.destroy

#     assert_equal(1, Audit::WishlistItem.where(object_id: wishlist_item.id, action: 'DELETE').count)
#     assert(audit_record = Audit::WishlistItem.find_by(object_id: wishlist_item.id,
#                                                       action: 'DELETE'))
#     assert_equal({}, audit_record.new_value)
#   end
# end
