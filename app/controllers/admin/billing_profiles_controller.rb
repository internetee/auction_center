require 'countries'

module Admin
  class BillingProfilesController < BaseController
    before_action :authorize_user
    before_action :set_billing_profile, only: %i[show edit update destroy]

    # GET /admin/billing_profiles
    def index
      sort_column = params[:sort].presence_in(%w[users.surname name vat_code]) || 'users.surname'
      sort_direction = params[:direction].presence_in(%w[asc desc]) || 'desc'

      billing_profiles = BillingProfile.accessible_by(current_ability)
                                       .includes(:user)
                                       .search(params)
                                       .order("#{sort_column} #{sort_direction}")

      @pagy, @billing_profiles = pagy(billing_profiles, items: params[:per_page] ||= 15)
    end

    # GET /admin/billing_profiles/12
    def show; end

    # GET /admin/billing_profiles/new
    def new
      @billing_profile = BillingProfile.new
    end

    # GET /admin/billing_profiles/12/edit
    def edit; end

    # POST /admin/billing_profiles
    def create
      @billing_profile = BillingProfile.new(billing_profile_params)

      respond_to do |format|
        if @billing_profile.save
          format.html do
            redirect_to admin_billing_profile_path(@billing_profile), notice: t('billing_profiles.created')
          end
          format.json { render :show, status: :created, location: admin_billing_profile_path(@billing_profile) }
        else
          format.html { render :new }
          format.json { render json: @billing_profile.errors, status: :unprocessable_entity }
        end
      end
    end

    # PUT /admin/billing_profiles/12
    def update
      respond_to do |format|
        if @billing_profile.update(update_params)
          format.html do
            redirect_to admin_billing_profile_path(@billing_profile), notice: t('billing_profiles.updated')
          end
          format.json { render :show, status: :ok, location: admin_billing_profile_path(@billing_profile) }
        else
          format.html { render :edit }
          format.json { render json: @billing_profile.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /admin/billing_profiles/12
    def destroy
      if @billing_profile.deletable?
        @billing_profile.destroy
        respond_to do |format|
          format.html { redirect_to admin_billing_profiles_path, notice: t('billing_profiles.deleted') }
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html { redirect_to admin_billing_profile_path(@billing_profile), alert: t('billing_profiles.in_use_by_offer') }
          format.json { render json: @billing_profile.errors, status: :unprocessable_entity }
        end
      end
    end

    private

    def set_billing_profile
      @billing_profile = BillingProfile.accessible_by(current_ability).find(params[:id])
    end

    def billing_profile_params
      params.require(:billing_profile)
            .permit(:name, :vat_code, :street, :city, :postal_code, :country_code, :user_id)
    end

    def update_params
      update_params = params.require(:billing_profile)
                            .permit(:name, :vat_code, :street, :city, :postal_code, :country_code)
      merge_updated_by(update_params)
    end

    def authorize_user
      authorize! :manage, BillingProfile
    end
  end
end
