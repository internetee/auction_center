# Preview all emails at http://localhost:3000/rails/mailers/auction_result_mailer
class AuctionResultMailerPreview < ActionMailer::Preview
  def winner_email
    AuctionResultMailer.winner_email(Result.first)
  end
end
