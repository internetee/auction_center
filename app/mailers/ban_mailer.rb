class BanMailer < ApplicationMailer
  def ban_email(ban)
    @ban = ban
    @user = @ban.user
    I18n.locale = @user.locale

    invoices = Invoice.where(user: @user, status: Invoice.statuses[:cancelled]).count

    @past_due_invoices = if I18n.locale == :en
                           invoices.ordinalize
                         else
                           invoices
                         end

    subject = if @ban.domain_name
                t('.subject_short_ban', domain_name: @ban.domain_name)
              else
                t('.subject_long_ban')
              end


    mail(to: @user.email, subject: subject)
  end
end
