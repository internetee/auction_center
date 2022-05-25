module Admin
  class BillingProfilesController < BaseController
    before_action :authorize_user

    # GET /admin/billing_profiles
    def index
      sort_column = params[:sort].presence_in(%w{ users.surname name  vat_code }) || "users.surname"
      sort_direction = params[:direction].presence_in(%w{ asc desc }) || "desc"

      billing_profiles = BillingProfile.accessible_by(current_ability)
                                       .includes(:user)
                                       .search(params)
                                       .order("#{sort_column} #{sort_direction}")

      @pagy, @billing_profiles = pagy(billing_profiles, items: params[:per_page] ||= 15)
    end

    # GET /admin/billing_profiles/12
    def show
      @billing_profile = BillingProfile.accessible_by(current_ability).find(params[:id])
    end

    private

    def authorize_user
      authorize! :manage, BillingProfile
    end

  end
end
