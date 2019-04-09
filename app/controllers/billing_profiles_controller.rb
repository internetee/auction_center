class BillingProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_billing_profile, only: %i[show edit update destroy]
  before_action :authorize_billing_profile_for_user, except: %i[new index create]

  # GET /billing_profiles
  def index
    @billing_profiles = BillingProfile.accessible_by(current_ability)
                                      .where(user_id: current_user.id)
  end

  # GET /billing_profiles/new
  def new
    @billing_profile = BillingProfile.new(user_id: current_user.id)
  end

  # POST /billing_profiles
  def create
    @billing_profile = BillingProfile.new(create_params)
    authorize! :manage, @billing_profile

    respond_to do |format|
      if create_predicate
        format.html { redirect_to billing_profile_path(@billing_profile.uuid), notice: t(:created) }
        format.json { render :show, status: :created, location: @billing_profile }
      else
        format.html { render :new }
        format.json { render json: @billing_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /billing_profiles/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b
  def show; end

  # GET /billing_profiles/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b/edit
  def edit; end

  # PUT /billing_profiles/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b
  def update
    respond_to do |format|
      if update_predicate
        format.html { redirect_to billing_profile_path(@billing_profile.uuid), notice: t(:updated) }
        format.json { render :show, status: :ok, location: @billing_profile }
      else
        format.html { render :edit }
        format.json { render json: @billing_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /billing_profiles/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b
  def destroy
    @billing_profile.destroy

    respond_to do |format|
      format.html { redirect_to billing_profiles_path, notice: t(:deleted) }
      format.json { head :no_content }
    end
  end

  private

  def create_predicate
    @billing_profile.save && @billing_profile.reload
  end

  def create_params
    create_params = params.require(:billing_profile).permit(
      :user_id, :name, :vat_code, :legal_entity, :street, :city, :postal_code, :country_code
    )

    create_params.reject! { |_k, v| v.empty? }
  end

  def update_predicate
    @billing_profile.update(update_params)
  end

  def update_params
    update_params = params.require(:billing_profile).permit(
      :name, :vat_code, :legal_entity, :street, :city, :postal_code, :country_code
    )

    update_params.reject! { |_k, v| v.empty? }
    merge_updated_by(update_params)
  end

  def set_billing_profile
    @billing_profile = BillingProfile.accessible_by(current_ability)
                                     .where(user_id: current_user.id)
                                     .find_by!(uuid: params[:uuid])
  end

  def authorize_billing_profile_for_user
    authorize! :manage, @billing_profile
  end
end
