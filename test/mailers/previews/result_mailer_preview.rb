# Preview all emails at http://localhost:3000/rails/mailers/auction_result_mailer
class ResultMailerPreview < ActionMailer::Preview
  def winner_email
    ResultMailer.winner_email(Result.first)
  end
end
