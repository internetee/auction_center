module Admin
  class BillingProfilesController < BaseController
    include OrderableHelper

    before_action :authorize_user

    # GET /admin/billing_profiles
    def index
      @billing_profiles = BillingProfile.accessible_by(current_ability)
                                        .includes(:user)
                                        .order(orderable_array(default_order_params))
                                        .page(params[:page])
    end

    # GET /admin/billing_profiles/search
    def search
      search_string = search_params[:search_string]
      @origin = search_string || search_params.dig(:order, :origin)
      @billing_profiles = BillingProfile.accessible_by(current_ability)
                                        .joins(:user)
                                        .includes(:user)
                                        .where(
                                          'billing_profiles.name ILIKE ? OR ' \
                                          'users.email ILIKE ? OR users.surname ILIKE ?',
                                          "%#{@origin}%",
                                          "%#{@origin}%",
                                          "%#{@origin}%"
                                        )
                                        .order(orderable_array(default_order_params))
                                        .page(1)
    end

    # GET /admin/billing_profiles/12
    def show
      @billing_profile = BillingProfile.accessible_by(current_ability).find(params[:id])
    end

    private

    def search_params
      search_params_copy = params.dup
      search_params_copy.permit(:search_string, order: :origin)
    end

    def authorize_user
      authorize! :manage, BillingProfile
    end

    def default_order_params
      { 'billing_profiles.created_at' => 'desc' }
    end
  end
end
