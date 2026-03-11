class BanMailerPreview < ActionMailer::Preview
  def ban_mail_english
    user = User.new(email: 'some@email.com', locale: :en,
                    given_names: 'GivenNames', surname: 'Surname')
    invoice = Invoice.new(payment_link: 'http://link.test')
    ban = Ban.new(user: user, invoice: invoice)

    BanMailer.ban_mail(ban, 2, 'banned.test')
  end

  def ban_mail_estonian
    user = User.new(email: 'some@email.com', locale: :et,
                    given_names: 'GivenNames', surname: 'Surname')
    invoice = Invoice.new(payment_link: 'http://link.test')
    ban = Ban.new(user: user, invoice: invoice)

    BanMailer.ban_mail(ban, 2, 'banned.test')
  end

  def final_ban_mail_english
    user = User.new(email: 'some@email.com', locale: :en,
                    given_names: 'GivenNames', surname: 'Surname')
    invoice = Invoice.new(payment_link: 'http://link.test')
    ban = Ban.new(user: user, invoice: invoice, valid_until: Date.today + 365)

    BanMailer.final_ban_mail(ban, 3, 'banned.test')
  end

  def final_ban_mail_estonian
    user = User.new(email: 'some@email.com', locale: :et,
                    given_names: 'GivenNames', surname: 'Surname')
    invoice = Invoice.new(payment_link: 'http://link.test')
    ban = Ban.new(user: user, invoice: invoice, valid_until: Date.today + 365)

    BanMailer.final_ban_mail(ban, 3, 'banned.test')
  end
end
