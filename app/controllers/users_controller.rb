require 'countries'

# rubocop:disable Metrics
class UsersController < ApplicationController
  include UserNotices
  before_action :authenticate_user!, only: %i[show edit update destroy edit_authwall]
  before_action :set_user, only: %i[show edit update destroy]
  before_action :set_minimum_password_length, only: %i[new edit]
  before_action :authorize_user, except: %i[new index create show edit_authwall
                                            toggle_subscription]

  # GET /users
  def index; end

  # GET /users/new
  def new
    redirect_to user_path(current_user.uuid), notice: t('.already_signed_in') if current_user
    @user = User.new
  end

  # GET /profile/edit
  def edit_authwall
    redirect_to user_path(current_user.uuid)
  end

  # GET /profile/toggle_daily_subscription
  def toggle_subscription
    @user = current_user
    @user.daily_summary = !@user.daily_summary
    @user.save!
    redirect_to :auctions, notice: t('.subscription_status_toggled_flash')
  end

  # POST /users/new
  def create
    @user = User.new(create_params)

    respond_to do |format|
      if @user.save
        format.html do
          sign_in(User, @user)
          redirect_to user_path(@user.uuid), notice: t(:created)
        end

        format.json do
          sign_in(User, @user)
          render :show, status: :created, location: @user
        end
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /users/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b
  def show
    authorize! :read, @user
  end

  # GET /users/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b/edit
  def edit
    return unless turbo_frame_request?

    render partial: 'form', locals: { user: @user }
  end

  # PUT /users/aa450f1a-45e2-4f22-b2c3-f5f46b5f906b
  def update
    respond_to do |format|
      if valid_password?
        @user.attributes = params_for_update
        email_changed = @user.email_changed?

        if @user.valid?
          @user.save!

          flash[:notice] = notification_for_update(email_changed)
          format.html do
            redirect_to user_path(@user.uuid)
          end
          format.json { render :show, status: :ok, location: @user }
        else
          flash.now[:alert] = @user.errors.full_messages.join(', ')
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      else
        flash.now[:alert] = t('.incorrect_password')
      end

      format.turbo_stream
    end
  end

  def destroy
    respond_to do |format|
      if @user.deletable? && @user.destroy!
        format.html { redirect_to root_path, notice: notification_for_delete(@user) }
      else
        format.html { redirect_to user_path(@user.uuid), notice: notification_for_delete(@user) }
      end
      format.json { head :no_content }
    end
  end

  private

  def create_params
    params.require(:user)
          .permit(:email, :password, :password_confirmation, :country_code,
                  :given_names, :surname, :mobile_phone, :accepts_terms_and_conditions,
                  :locale, :daily_summary, :identity_code)
  end

  def params_for_update
    update_params = params.require(:user)
                          .permit(:email, :password, :password_confirmation, :country_code,
                                  :identity_code, :given_names, :surname, :mobile_phone,
                                  :accepts_terms_and_conditions, :daily_summary)

    update_params.reject! { |k, v| v.empty? || (k == 'identity_code' && @user.identity_code.present?) }
    merge_updated_by(update_params)
  end

  def valid_password?
    @user.signed_in_with_identity_document? ||
      @user.valid_password?(params.dig(:user, :current_password))
  end

  def set_minimum_password_length
    @minimum_password_length = User.password_length.min
  end

  def set_user
    @user = User.accessible_by(current_ability).find_by!(uuid: params[:uuid])
  end

  def authorize_user
    authorize! :manage, @user
  end
end
