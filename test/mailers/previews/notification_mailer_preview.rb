class NotificationMailerPreview < ActionMailer::Preview
  def daily_summary_email_english
    user = User.new(email: "some@email.com", locale: :en)
    NotificationMailer.daily_summary_email(user)
  end
end
