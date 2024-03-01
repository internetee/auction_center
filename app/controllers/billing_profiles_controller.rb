# rubocop:disable Metrics
class BillingProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_billing_profile, only: %i[show edit update destroy]
  before_action :authorize_billing_profile_for_user, except: %i[new index create]
  before_action :store_location, only: :new

  rescue_from ActiveRecord::RecordNotUnique do |_exception|
    flash[:alert] = t('billing_profiles.vat_code_already_exists')
    render turbo_stream: turbo_stream.replace('flash', partial: 'common/flash', locals: { flash: })
  end

  # GET /billing_profiles
  def index
    @billing_profiles = BillingProfile.accessible_by(current_ability)
                                      .where(user_id: current_user.id)
  end

  # GET /billing_profiles/new
  def new
    @billing_profile = BillingProfile.new(user_id: current_user.id)

    return unless turbo_frame_request?

    render partial: 'new_form', locals: { billing_profile: @billing_profile }
  end

  def create
    @billing_profile = BillingProfile.new(create_params)
    authorize! :manage, @billing_profile

    flash.clear

    respond_to do |format|
      if create_predicate
        redirect_uri = "#{session[:return_to]}?billing_profile_id=#{@billing_profile.id}" || billing_profile_path(@billing_profile.uuid)
        flash[:notice] = t(:created)

        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace('flash', partial: 'common/flash', locals: { flash: }),
            turbo_stream.prepend('billing_profile_containers', partial: 'billing_profiles/billing_info',
                                                               locals: { billing_profile: @billing_profile }),
            turbo_stream.remove('new_form')
          ]
        end
        format.html { redirect_to redirect_uri }
        format.json { render :show, status: :created, location: @billing_profile }
      else
        flash.now[:alert] = @billing_profile.errors.full_messages.to_sentence

        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace('flash', partial: 'common/flash', locals: { flash: })
          ]
        end
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @billing_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /billing_profiles/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b
  def show; end

  # GET /billing_profiles/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b/edit
  def edit
    return unless turbo_frame_request?

    render partial: 'form', locals: { billing_profile: @billing_profile }
  end

  # PUT /billing_profiles/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b
  def update
    respond_to do |format|
      if update_predicate
        flash[:notice] = t(:updated)

        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace('flash', partial: 'common/flash', locals: { flash: }),
            turbo_stream.update(@billing_profile, partial: 'billing_profiles/billing_info',
                                                  locals: { billing_profile: @billing_profile })
          ]
        end

        format.html { redirect_to billing_profiles_path, notice: t(:updated) }
        format.json { render :show, status: :ok, location: @billing_profile }
      else
        flash[:alert] = @billing_profile.errors.full_messages.to_sentence

        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace('flash', partial: 'common/flash', locals: { flash: })
          ]
        end

        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @billing_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /billing_profiles/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b
  def destroy
    if @billing_profile.deletable?
      @billing_profile.destroy!

      flash[:notice] = t(:deleted)
      render turbo_stream: [
        turbo_stream.replace('flash', partial: 'common/flash', locals: { flash: }),
        turbo_stream.remove(@billing_profile)
      ]
    else
      flash[:alert] = @billing_profile.errors.full_messages.to_sentence
      render turbo_stream: [
        turbo_stream.replace('flash', partial: 'common/flash', locals: { flash: })
      ]
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
    params.require(:billing_profile).permit(
      :name, :vat_code, :legal_entity, :street, :city, :postal_code, :country_code
    )
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
