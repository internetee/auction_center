require 'messente/omnimessage'

class PhoneConfirmation
  attr_reader :user

  TIME_LIMIT = AuctionCenter::Application.config.customization[:mobile_sms_sent_time_limit_in_minutes].to_i.minutes || 1.minutes

  def initialize(user)
    @user = user
  end

  def generate_and_send_code
    return unless user.valid?
    return if user.mobile_phone_confirmed_sms_send_at.present? && user.mobile_phone_confirmed_sms_send_at > TIME_LIMIT.ago

    number = SecureRandom.random_number(10_000)
    padded_number = format('%04d', number)

    user.update!(mobile_phone_confirmation_code: padded_number, mobile_phone_confirmed_sms_send_at: Time.zone.now)
    message_sender = Messente::Omnimessage.new(
      user.mobile_phone,
      I18n.t('phone_confirmations.instructions', code: padded_number)
    )
    message_sender.send_message
  end

  def code
    @user.mobile_phone_confirmation_code
  end

  def confirmed?
    @user.mobile_phone_confirmed_at.present?
  end

  def valid_code?(input_code)
    input_code == code
  end

  def confirm
    return if confirmed?

    @user.update!(mobile_phone_confirmed_at: Time.zone.now)
  end
end
