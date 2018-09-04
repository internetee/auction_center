require 'countries'

class UsersController < ApplicationController
  before_action :set_minimum_password_length, only: %i[new edit]
  before_action :set_user, only: %i[show edit update destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      sign_in(User, @user)
      redirect_to users_path(user, notice: 'Your account was created.')
    else
      render :new
    end
  end

  def edit; end

  def update
    @user.update(update_params)
  end

  private

  def user_params
    params.require(:user)
          .permit(:email, :password, :password_confirmation, :identity_code,
                  :country_code, :given_names, :surname)
  end

  def update_params
    params.require(:user)
          .permit(:email, :password, :password_confirmation)
  end

  def set_minimum_password_length
    @minimum_password_length = User.password_length.min
  end

  def set_user
    @user = User.find(params[:id])
  end
end
