class BanMailerPreview < ActionMailer::Preview
  EMAIL = 'some@email.com'
  LINK_URL = 'http://link.test'
  DOMAIN_NAME = 'banned.test'
  
  def ban_mail_english
    user = User.new(email: EMAIL, locale: :en,
                    given_names: 'GivenNames', surname: 'Surname')
    invoice = Invoice.new(payment_link: LINK_URL)
    ban = Ban.new(user: user, invoice: invoice)

    BanMailer.ban_mail(ban, 2, DOMAIN_NAME)
  end

  def ban_mail_estonian
    user = User.new(email: EMAIL, locale: :et,
                    given_names: 'GivenNames', surname: 'Surname')
    invoice = Invoice.new(payment_link: LINK_URL)
    ban = Ban.new(user: user, invoice: invoice)

    BanMailer.ban_mail(ban, 2, DOMAIN_NAME)
  end

  def final_ban_mail_english
    user = User.new(email: EMAIL, locale: :en,
                    given_names: 'GivenNames', surname: 'Surname')
    invoice = Invoice.new(payment_link: LINK_URL)
    ban = Ban.new(user: user, invoice: invoice, valid_until: Date.today + 365)

    BanMailer.final_ban_mail(ban, 3, DOMAIN_NAME)
  end

  def final_ban_mail_estonian
    user = User.new(email: EMAIL, locale: :et,
                    given_names: 'GivenNames', surname: 'Surname')
    invoice = Invoice.new(payment_link: LINK_URL)
    ban = Ban.new(user: user, invoice: invoice, valid_until: Date.today + 365)

    BanMailer.final_ban_mail(ban, 3, DOMAIN_NAME)
  end
end
