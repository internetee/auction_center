class BanMailerPreview < ActionMailer::Preview
  def ban_mail_english
    user = User.new(email: 'some@email.com', locale: :en,
                    given_names: 'GivenNames', surname: 'Surname')
    ban = Ban.new(user: user)

    BanMailer.ban_mail(ban, 2, 'banned.test')
  end

  def ban_mail_estonian
    user = User.new(email: 'some@email.com', locale: :et,
                    given_names: 'GivenNames', surname: 'Surname')
    ban = Ban.new(user: user)

    BanMailer.ban_mail(ban, 2, 'banned.test')
  end
end
