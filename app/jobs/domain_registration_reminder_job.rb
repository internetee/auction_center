class DomainRegistrationReminderJob < ApplicationJob
  def perform
    results = Result.where(status: Result.statuses[:payment_received])
                    .where('registration_due_date <= ?', Time.zone.today + 5)
                    .where('registration_reminder_sent_at IS NULL')

    results.map do |result|
      DomainRegistrationMailer.registration_reminder_email(result).deliver_now
    end
  end
end
