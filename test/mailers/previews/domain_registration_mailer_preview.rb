class DomainRegistrationMailerPreview < ActionMailer::Preview
  def registration_reminder_email
    DomainRegistrationMailer.registration_reminder_email(
      Result.where("status <> 'no_bids'").last
    )
  end
end
