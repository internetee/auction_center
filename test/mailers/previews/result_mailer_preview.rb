# Preview all emails at http://localhost:3000/rails/mailers/auction_result_mailer
class ResultMailerPreview < ActionMailer::Preview
  def winner_email_english
    user = User.new(email: 'some@email.com', locale: :en,
                    given_names: 'GivenNames', surname: 'Surname')
    auction = Auction.new(domain_name: 'example.test')
    result = Result.new(user: user, auction: auction, registration_code: 'registration code',
                        uuid: SecureRandom.uuid)
    ResultMailer.winner_email(result)
  end

  def winner_email_estonian
    user = User.new(email: 'some@email.com', locale: :et,
                    given_names: 'GivenNames', surname: 'Surname')
    auction = Auction.new(domain_name: 'example.test')
    result = Result.new(user: user, auction: auction, registration_code: 'registration code',
                        uuid: SecureRandom.uuid)
    ResultMailer.winner_email(result)
  end

  def registration_code_email_english
    user = User.new(email: 'some@email.com', locale: :en,
                    given_names: 'GivenNames', surname: 'Surname')
    auction = Auction.new(domain_name: 'example.test')
    result = Result.new(user: user, auction: auction, registration_code: 'registration code',
                        uuid: SecureRandom.uuid)

    ResultMailer.registration_code_email(result)
  end

  def registration_code_email_estonian
    user = User.new(email: 'some@email.com', locale: :et,
                    given_names: 'GivenNames', surname: 'Surname')
    auction = Auction.new(domain_name: 'example.test')
    result = Result.new(user: user, auction: auction, registration_code: 'registration code',
                        uuid: SecureRandom.uuid)

    ResultMailer.registration_code_email(result)
  end

  def participant_email_english
    user = User.new(email: 'some@email.com', locale: :en,
                    given_names: 'GivenNames', surname: 'Surname')
    auction = Auction.new(domain_name: 'example.test')

    ResultMailer.participant_email(user, auction)
  end

  def participant_email_estonian
    user = User.new(email: 'some@email.com', locale: :et,
                    given_names: 'GivenNames', surname: 'Surname')
    auction = Auction.new(domain_name: 'example.test')

    ResultMailer.participant_email(user, auction)
  end
end
