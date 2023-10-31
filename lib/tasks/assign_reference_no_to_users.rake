namespace :reference_no do
  desc 'Get reference number from billing and assign it to user record'

  task assign_to_users: :environment do
    User.all.each(&:assign_reference_no)
  end
end
