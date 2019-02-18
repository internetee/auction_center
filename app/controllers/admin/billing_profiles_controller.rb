module Admin
  class BillingProfilesController < BaseController
    before_action :authorize_user

    # GET /admin/billing_profiles
    def index
      @billing_profiles = BillingProfile.accessible_by(current_ability).page(params[:page])
    end

    def authorize_user
      authorize! :manage, BillingProfile
    end
  end
end
