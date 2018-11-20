class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.config.customization['email_from_address']
  layout 'mailer'
end
