class ApplicationMailer < ActionMailer::Base
  before_action :add_smtputf8_header
  after_action :convert_email_to_punycode

  default from: Rails.application.config.customization['email_from_address']
  layout 'mailer'

  private

  def add_smtputf8_header
    headers['SMTPUTF8'] = 'true'
  end

  def convert_email_to_punycode
    convert_recipient_to_punycode
    convert_carbon_copy_to_punycode
    convert_blind_carbon_copy_to_punycode
  end

  def convert_recipient_to_punycode
    mail.to = Array(mail.to).map { |email| convert_domain_to_punycode(email) }
  end

  def convert_carbon_copy_to_punycode
    mail.cc = Array(mail.cc).map { |email| convert_domain_to_punycode(email) }
  end

  def convert_blind_carbon_copy_to_punycode
    mail.bcc = Array(mail.bcc).map { |email| convert_domain_to_punycode(email) }
  end

  def convert_domain_to_punycode(email)
    local, domain = email.split('@')
    domain = SimpleIDN.to_ascii(domain)
    "#{local}@#{domain}"
  end
end
