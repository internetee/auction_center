class DomainRegistrationReminderJob < ApplicationJob
  def perform
    Result.pending_registration_reminder.map do |result|
      DomainRegistrationMailer.registration_reminder_email(result).deliver_now
    end
  end

  def self.needs_to_run?
    Result.pending_registration_reminder.any?
  end
end
