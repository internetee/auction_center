class DailySummaryJob < ApplicationJob
  def perform
    User.where("'administrator' = ANY (roles)").each do |administrator|
      NotificationMailer.daily_summary_email(administrator).deliver_later
    end
  end

  def self.needs_to_run?
    true
  end
end
