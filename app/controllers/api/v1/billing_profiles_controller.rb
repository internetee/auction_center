module Api
  module V1
    class BillingProfilesController < BaseController
      respond_to :json

      skip_before_action :verify_authenticity_token

      rescue_from ActiveRecord::RecordNotUnique, with: :handle_unique_violation

      def index
        @billing_profiles = current_user.billing_profiles

        render json: { billing_profiles: @billing_profiles }
      end

      def update
        @billing_profile = current_user.billing_profiles.find(params[:id])

        if @billing_profile.update(billing_profile_params)
          render json: { billing_profile: @billing_profile }
        else
          render json: { errors: @billing_profile.errors }, status: 422
        end
      end

      def create
        @billing_profile = current_user.billing_profiles.new(billing_profile_params)

        if @billing_profile.save
          render json: { billing_profile: @billing_profile }
        else
          render json: { errors: @billing_profile.errors }, status: 422
        end
      end

      private

      def billing_profile_params
        params.require(:billing_profile).permit(:name, :vat_code, :street, :city, :state, :postal_code,
                                                :alpha_two_country_code, :uuid)
      end

      def handle_unique_violation
        render json: { errors: 'A billing profile with the same VAT code for this user already exists.' }, status: 422
      end
    end
  end
end
