# require 'application_system_test_case'

# class AdminVersionsTest < ApplicationSystemTestCase
#   def setup
#     super

#     @administrator = users(:administrator)
#     sign_in(@administrator)
#   end

#   def test_it_shows_history_of_updated_fields
#     @administrator.update(given_names: 'New Given Name', surname: 'New Surname')
#     visit admin_user_versions_path(@administrator)

#     page.within('tr.items-table-row') do
#       assert_text('New Given Name')
#       assert_text('New Surname')
#     end
#   end

#   def test_it_can_be_accessed_after_the_object_has_been_deleted
#     user = users(:participant)
#     user.update(given_names: 'New Given Name', surname: 'New Surname')
#     user.destroy
#     visit admin_user_versions_path(user)

#     page.within('tbody.items-table-body') do
#       assert_text('DELETE')
#       assert_text('New Given Name')
#       assert_text('New Surname')
#     end
#   end
# end
