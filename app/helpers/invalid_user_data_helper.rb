module InvalidUserDataHelper
  def set_invalid_data_flag_in_session
    return unless current_user

    session['user.invalid_user_data'] = user_data_invalid?
  end

  def invalid_data_banner
    return unless session['user.invalid_user_data']

    if current_user.not_phone_number_confirmed_unique?
      content_tag(:div, class: 'ui message flash') do
        content_tag(:div, t('already_confirmed'), class: 'header')
      end
    else
      content_tag(:div, class: 'ui message ban') do
        content_tag(:div, t('users.invalid_user_data'), class: 'header')
      end
    end
  end

  private

  def user_data_invalid?
    current_user.invalid? &&
      current_user.errors.messages.keys.any? { |key| %i[given_names surname mobile_phone].include?(key) } ||
      (current_user.billing_profiles.present? && current_user.billing_profiles.any?(&:invalid?))
  end
end
