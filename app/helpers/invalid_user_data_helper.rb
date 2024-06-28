module InvalidUserDataHelper
  def set_invalid_data_flag_in_session
    return unless current_user

    session['user.invalid_user_data'] = user_data_invalid?
  end

  private

  def user_data_invalid?
    current_user.invalid? &&
      current_user.errors.messages.keys.any? { |key| %i[given_names surname mobile_phone].include?(key) } ||
      (current_user.billing_profiles.present? && current_user.billing_profiles.any?(&:invalid?))
  end
end
