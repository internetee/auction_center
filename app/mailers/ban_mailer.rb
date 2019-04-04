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
    mail(to: @user.email, subject: set_subject)
  end

  def short_ban_mail(ban, ban_strikes, domain_name)
    @ban = ban
    @user = @ban.user
    @domain_name = domain_name

    I18n.locale = @user.locale
    @past_due_invoices = if I18n.locale == :en
                           ban_strikes.ordinalize
                         else
                           ban_strikes
                         end

    mail(to: @user.email, subject: t('.subject', domain_name: domain_name))
  end

  def long_ban_mail(ban, ban_strikes, domain_name)
    @ban = ban
    @user = @ban.user
    @domain_name = domain_name
    I18n.locale = @user.locale

    @past_due_invoices = if I18n.locale == :en
                           ban_strikes.ordinalize
                         else
                           ban_strikes
                         end

    mail(to: @user.email, subject: t('.subject'))
  end

  private

  def set_subject
    if @ban.domain_name
      t('.subject_short_ban', domain_name: @ban.domain_name)
    else
      t('.subject_long_ban')
    end
  end
end
