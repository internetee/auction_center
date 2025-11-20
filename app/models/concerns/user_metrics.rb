# frozen_string_literal: true

# User metrics tracking for Yabeda
module UserMetrics
  extend ActiveSupport::Concern

  included do
    after_create :track_user_registration
    after_update :track_user_confirmation, if: :saved_change_to_confirmed_at?
  end

  private

  def track_user_registration
    provider_name = provider.presence || "password"
    Yabeda.user_business.user_registrations_total.increment(provider: provider_name)
  end

  def track_user_confirmation
    return unless confirmed_at.present?

    provider_name = provider.presence || "password"
    Yabeda.user_business.user_confirmed_total.increment(provider: provider_name)

    # Update gauge for TARA unconfirmed users
    if provider == User::TARA_PROVIDER
      count = User.where(provider: User::TARA_PROVIDER, confirmed_at: nil).count
      Yabeda.user_business.user_tara_unconfirmed_total.set({}, count)
    end
  end
end
