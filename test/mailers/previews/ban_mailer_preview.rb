class BanMailerPreview < ActionMailer::Preview
  def short_ban_mail_english
    user = User.new(email: 'some@email.com', locale: :en)
    ban = Ban.new(user: user)

    BanMailer.short_ban_mail(ban, 2, 'banned.test')
  end

  def short_ban_mail_estonian
    user = User.new(email: 'some@email.com', locale: :et)
    ban = Ban.new(user: user)

    BanMailer.short_ban_mail(ban, 2, 'banned.test')
  end

  def long_ban_mail_english
    user = User.new(email: 'some@email.com', locale: :en)
    ban = Ban.new(user: user, valid_until: Date.today >> 12)

    BanMailer.long_ban_mail(ban, 4, 'banned.test')
  end

  def long_ban_mail_estonian
    user = User.new(email: 'some@email.com', locale: :et)
    ban = Ban.new(user: user, valid_until: Date.today >> 12)

    BanMailer.long_ban_mail(ban, 4, 'banned.test')
  end
end
