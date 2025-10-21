# frozen_string_literal: true

module Users
  class EmailConfirmationController < ApplicationController
    RESEND_INTERVAL = 2.minutes

    before_action :rate_limited!, only: :create, if: :rate_limited?

    def create
      current_user.send_confirmation_instructions
      update_last_confirmation_sent_at

      flash[:notice] = t('users.email_confirmation_sent')
      redirect_to user_path(current_user.uuid), status: :see_other
    end

    private

    def rate_limited!
      flash[:alert] = t('users.email_confirmation_rate_limited',
                        wait_time: time_until_next_send)
      redirect_to user_path(current_user.uuid), status: :see_other
      nil
    end

    def rate_limited?
      return false unless current_user.confirmation_sent_at.present?

      current_user.confirmation_sent_at > RESEND_INTERVAL.ago
    end

    def time_until_next_send
      return 0 unless current_user.confirmation_sent_at.present?

      seconds_left = (current_user.confirmation_sent_at + RESEND_INTERVAL - Time.current).to_i
      minutes = (seconds_left / 60.0).ceil

      "#{minutes} #{I18n.t('datetime.prompts.minute', count: minutes)}"
    end

    def update_last_confirmation_sent_at
      current_user.update_column(:confirmation_sent_at, Time.current)
    end
  end
end
