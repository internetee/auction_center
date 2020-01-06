class DomainRegistrationReminderJob < ApplicationJob
  def perform
    scope.map do |result|
      DomainRegistrationMailer.registration_reminder_email(result).deliver_now
    end
  end

  def self.needs_to_run?
    scope.any?
  end

  def self.scope
    setting = Setting.find_by(code: :domain_registration_daily_reminder).retrieve
    if setting.positive?
      Result.pending_registration_everyday_reminder
    else
      Result.pending_registration_reminder
    end
  end

  def scope
    self.class.scope
  end
end
