class BanMailerPreview < ActionMailer::Preview
  def short_ban_mail
    BanMailer.short_ban_mail(Ban.first, 2, 'banned.test')
  end

  def long_ban_mail
    BanMailer.long_ban_mail(Ban.first, 4, 'banned.test')
  end
end
