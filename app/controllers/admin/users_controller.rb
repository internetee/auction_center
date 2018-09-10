module Admin
  class UsersController < BaseController
    load_and_authorize_resource
    before_action :set_user, except: [:index, :new]

    # GET /admin/users
    def index
      @users = User.all.order(created_at: :desc)
    end

    # GET /admin/users/1
    def show; end

    # GET /admin/users/1/edit
    def edit; end

    # PUT /admin/users/1
    def update
      respond_to do |format|
        if @user.update(update_params)
          format.html { redirect_to admin_user_path(@user) }
          format.json { render :show, status: :ok, location: admin_user_path(@user) }
        else
          format.html { render :edit }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELET /admin/users/1
    def destroy; end

    private

    def update_params
      update_params = params.require(:user)
                            .permit(:email, :given_names, :surname, :mobile_phone, roles: [])
      update_params.reject! { |_k, v| v.blank? }
    end

    def set_user
      @user = User.find(params[:id])
    end
  end
end
