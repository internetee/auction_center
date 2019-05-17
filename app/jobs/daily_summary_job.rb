class DailySummaryJob < ApplicationJob
  def perform
    User.where('? = ANY (roles)', User::ADMINISTATOR_ROLE).each do |administrator|
      NotificationMailer.daily_summary_email(administrator).deliver_later
    end
  end

  def self.needs_to_run?
    true
  end
end
