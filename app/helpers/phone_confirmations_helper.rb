module PhoneConfirmationsHelper
  def render_send_in_button?
    Setting.find_by(code: 'require_phone_confirmation').retrieve &&
      current_user.mobile_phone_confirmed_at.nil? &&
      current_user.mobile_phone.present?
  end
end
