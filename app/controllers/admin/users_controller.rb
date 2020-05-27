require 'countries'

module Admin
  class UsersController < BaseController
    include OrderableHelper

    before_action :authorize_user
    before_action :set_user, except: %i[index new create search]
    before_action :set_phone_confirmation_toggle, only: %i[index show]

    # GET /admin/users/new
    def new
      @user = User.new
    end

    # GET /admin/users
    def index
      @users = User.all
                   .order(orderable_array(default_order_params))
                   .page(params[:page])
    end

    # GET /admin/users/search
    def search
      search_string = search_params[:search_string]
      @origin = search_string || search_params.dig(:order, :origin)

      @users = User.where('email ILIKE ? OR surname ILIKE ? OR given_names ILIKE ? ' \
                          'OR mobile_phone ILIKE ?',
                          "%#{@origin}%", "%#{@origin}%", "%#{@origin}%",
                          "%#{@origin}%")
                   .accessible_by(current_ability)
                   .order(orderable_array)
                   .page(1)
    end

    # POST /admin/users
    def create
      @user = User.new(create_params)

      respond_to do |format|
        if @user.save && @user.send_confirmation_instructions
          format.html do
            redirect_to admin_user_path(@user), notice: t(:created)
          end

          format.json do
            render :show, status: :created, location: @user
          end
        else
          format.html { render :new }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end

    # GET /admin/users/1
    def show
      @ban = Ban.new(user: @user)
    end

    # GET /admin/users/1/edit
    def edit; end

    # PUT /admin/users/1
    def update
      respond_to do |format|
        if @user.update!(update_params)
          format.html { redirect_to admin_user_path(@user) }
          format.json { render :show, status: :ok, location: admin_user_path(@user) }
        else
          format.html { render :edit }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /admin/users/1
    def destroy
      @user.destroy
      respond_to do |format|
        format.html { redirect_to admin_users_path, notice: t(:deleted) }
        format.json { head :no_content }
      end
    end

    private

    def search_params
      search_params_copy = params.dup
      search_params_copy.permit(:search_string, order: :origin)
    end

    def create_params
      params.require(:user)
            .permit(:email, :password, :password_confirmation, :identity_code, :country_code,
                    :given_names, :surname, :mobile_phone, :accepts_terms_and_conditions,
                    :daily_summary, roles: [])
    end

    def update_params
      update_params = params.require(:user)
                            .permit(:email, :password, :password_confirmation, :identity_code,
                                    :country_code, :given_names, :surname, :mobile_phone,
                                    :accepts_terms_and_conditions, :daily_summary, roles: [])
      update_params.reject! { |_k, v| v.empty? }
      merge_updated_by(update_params)
    end

    def authorize_user
      authorize! :manage, User
    end

    def set_user
      @user = User.includes(:billing_profiles).find(params[:id])
    end

    def set_phone_confirmation_toggle
      @phone_confirmation_toggle = Setting.find_by(code: 'require_phone_confirmation').retrieve
    end

    def default_order_params
      { 'users.created_at' => 'desc' }
    end
  end
end
