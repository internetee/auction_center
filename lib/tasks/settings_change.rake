namespace :settings do
  desc ''

  # rake settings:deadline_registration[30]
  task :deadline_registration, [:value] => [:environment] do |_t, args|
    registration_deadline = Setting.find_by_code(:registration_term)
    registration_deadline.update!(value: args[:value].to_s)
  end
end
