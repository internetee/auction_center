class BanMailerPreview < ActionMailer::Preview
  def ban_mailer
    BanMailer.ban_email(Ban.first)
  end
end
