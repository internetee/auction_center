class BillingProfilesController < ApplicationController
  before_action :set_billing_profile, only: %i[show edit update destroy]
  before_action :authorize_user, except: :new

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

    respond_to do |format|
      if @billing_profile.save
        format.html { redirect_to billing_profile_path(@billing_profile), notice: t(:created) }
        format.json { render :show, status: :created, location: @billing_profile }
      else
        format.html { render :new }
        format.json { render json: @billing_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /billing_profiles/1
  def show; end

  # GET /billing_profiles/1/edit
  def edit; end

  # PUT /billing_profiles/1
  def update
    respond_to do |format|
      if @billing_profile.update(update_params)
        format.html { redirect_to billing_profile_path(@billing_profile), notice: t(:updated) }
        format.json { render :show, status: :ok, location: @billing_profile }
      else
        format.html { render :edit }
        format.json { render json: @billing_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /billing_profiles/1
  def destroy
    @billing_profile.destroy

    respond_to do |format|
      format.html { redirect_to billing_profiles_path, notice: t(:deleted) }
      format.json { head :no_content }
    end
  end

  private

  def create_params
    params.require(:billing_profile).permit(
      :user_id, :name, :vat_code, :legal_entity, :street, :city, :postal_code, :country
    )
  end

  def update_params
    params.require(:billing_profile).permit(
      :name, :vat_code, :legal_entity, :street, :city, :postal_code, :country
    )
  end

  def set_billing_profile
    @billing_profile = BillingProfile.accessible_by(current_ability)
                                     .where(user_id: current_user.id)
                                     .find(params[:id])
  end

  def authorize_user
    authorize! :manage, BillingProfile
  end
end
