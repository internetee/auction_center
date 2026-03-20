module Admin
  module Bans
    class DomainBansController < Admin::BaseController
      before_action :authorize_user

      def create
        @ban = Ban.new(ban_params)
        @ban.valid_from = Time.zone.now

        validate_domain_name_presence

        respond_to do |format|
          if @ban.errors.none? && @ban.save
            format.html { redirect_to admin_bans_path, notice: t(:created) }
            format.json { render json: @ban, status: :created }
          else
            format.html do
              redirect_to admin_user_path(@ban.user_id),
                          alert: @ban.errors.full_messages.to_sentence
            end
            format.json { render json: @ban.errors, status: :unprocessable_entity }
          end
        end
      end

      private

      def ban_params
        params.require(:ban).permit(:user_id, :domain_name, :valid_until, :invoice_id)
      end

      def validate_domain_name_presence
        return if @ban.domain_name.present?

        @ban.errors.add(:domain_name, :blank)
      end

      def authorize_user
        authorize! :manage, Ban
      end
    end
  end
end
