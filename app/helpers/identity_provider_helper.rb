module IdentityProviderHelper
  # eeID is used only when it is configured and switched on by the
  # `eeid_login_enabled` setting; otherwise sign-in falls back to TARA.
  def eeid_login_enabled?
    return @eeid_login_enabled if defined?(@eeid_login_enabled)

    @eeid_login_enabled = AuctionCenter::Application.config.customization[:eeid].present? &&
                          Setting.find_by(code: 'eeid_login_enabled')&.retrieve == true
  end

  def identity_document_sign_in_path
    eeid_login_enabled? ? '/auth/eeid' : '/auth/tara'
  end
end
