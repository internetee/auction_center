class InvoiceMailerPreview < ActionMailer::Preview
  def reminder_email_english
    user = User.new(email: 'some@email.com', locale: :en,
                    given_names: 'GivenNames', surname: 'Surname')
    auction = Auction.new(domain_name: 'example.test')
    billing_profile = BillingProfile.new(user: user)
    result = Result.new(user: user, auction: auction, registration_code: 'registration code',
                        uuid: SecureRandom.uuid)
    invoice = Invoice.new(result: result, user: user, billing_profile: billing_profile,
                          due_date: Date.today)

    InvoiceMailer.reminder_email(invoice)
  end

  def reminder_email_estonian
    user = User.new(email: 'some@email.com', locale: :et,
                    given_names: 'GivenNames', surname: 'Surname')
    auction = Auction.new(domain_name: 'example.test')
    billing_profile = BillingProfile.new(user: user)
    result = Result.new(user: user, auction: auction, registration_code: 'registration code',
                        uuid: SecureRandom.uuid)
    invoice = Invoice.new(result: result, user: user, billing_profile: billing_profile,
                          due_date: Date.today)

    InvoiceMailer.reminder_email(invoice)
  end
end
