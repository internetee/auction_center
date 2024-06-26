class ApplicationMailer < ActionMailer::Base
  before_action :add_smtputf8_header

  default from: Rails.application.config.customization['email_from_address']
  layout 'mailer'

  private

  def add_smtputf8_header
    headers['SMTPUTF8'] = 'true'
  end
end
