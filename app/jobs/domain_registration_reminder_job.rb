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
    setting = Setting.find_by(code: 'remind_on_domain_registration_everyday').retrieve
    setting ? Result.pending_registration_everyday_reminder : Result.pending_registration_reminder
  end

  def scope
    self.class.scope
  end
end
