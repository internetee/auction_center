module Admin
  class BillingProfilesController < BaseController
    include OrderableHelper

    before_action :authorize_user

    # GET /admin/billing_profiles
    def index
      @billing_profiles = BillingProfile.accessible_by(current_ability)
                                        .includes(:user)
                                        .order(orderable_array)
                                        .page(params[:page])
    end

    # GET /admin/billing_profiles/12
    def show
      @billing_profile = BillingProfile.accessible_by(current_ability).find(params[:id])
    end

    def authorize_user
      authorize! :manage, BillingProfile
    end
  end
end
