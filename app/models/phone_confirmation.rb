require 'messente/omnimessage'

class PhoneConfirmation
  attr_reader :user

  TIME_LIMIT = 1.minutes

  def initialize(user)
    @user = user
  end

  def generate_and_send_code
    return unless user.valid?
    return if user.mobile_phone_confirmed_sms_send_at.present? && user.mobile_phone_confirmed_sms_send_at > TIME_LIMIT.ago

    padded_number = generate_padded_number
    assign_padded_number_to_user(padded_number)
    locale = locale_for_sms(user)

    send_sms_with_locale(locale, padded_number)
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

  private

  def assign_padded_number_to_user(padded_number)
    user.update!(mobile_phone_confirmation_code: padded_number, mobile_phone_confirmed_sms_send_at: Time.zone.now)
  end

  def send_sms_with_locale(locale, padded_number)
    I18n.with_locale(locale) do
      message_sender = Messente::Omnimessage.new(
        user.mobile_phone,
        I18n.t('phone_confirmations.instructions', code: padded_number)
      )
      message_sender.send_message
    end
  end

  def generate_padded_number
    number = SecureRandom.random_number(10_000)
    format('%04d', number)
  end

  def locale_for_sms(user)
    force_english_localize = !user.mobile_phone.include?('+372')
    default_locale = user.locale.blank? ? I18n.default_locale : user.locale

    force_english_localize ? :en : default_locale
  end
end
