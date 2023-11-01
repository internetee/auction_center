class AdminMailer < ApplicationMailer
  def transaction_mail(transaction_info)
    administrators = User.where(roles: ['administrator']).pluck(:email)
    @transaction_info = transaction_info

    mail(to: administrators, subject: 'Undefined transaction')
  end
end
