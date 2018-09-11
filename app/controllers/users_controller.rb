require 'countries'

class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :set_minimum_password_length, only: %i[new edit]
  before_action :authorize_user, except: %i[new index create]

  def index; end

  def new
    @user = User.new
  end

  def create
    @user = User.new(create_params)

    respond_to do |format|
      if @user.save
        format.html do
          sign_in(User, @user)
          redirect_to user_path(@user), notice: t(:created_successfully)
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

  def edit; end

  def update
    if @user.valid_password?(params.dig(:user, :current_password))
      respond_to do |format|
        if @user.update(update_params)
          format.html { redirect_to @user, notice: t('devise.confirmations.send_instructions') }
          format.json { render :show, status: :ok, location: @user }
        else
          format.html { render :edit }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to edit_user_path(@user), notice: t('.incorrect_password')
    end
  end

  private

  def create_params
    params.require(:user)
          .permit(:email, :password, :password_confirmation, :identity_code,
                  :country_code, :given_names, :surname, :mobile_phone)
  end

  def update_params
    update_params = params.require(:user)
                          .permit(:email, :password, :password_confirmation,
                                  :given_names, :surname, :mobile_phone)
    update_params.reject! { |_k, v| v.blank? }
  end

  def set_minimum_password_length
    @minimum_password_length = User.password_length.min
  end

  def set_user
    @user = User.find(params[:id])
  end

  def authorize_user
    authorize! :manage, @user
  end
end
