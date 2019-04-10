require 'countries'

module Admin
  class SettingsController < BaseController
    before_action :set_setting, except: :index
    before_action :authorize_user

    # GET /admin/settings
    def index
      @settings = Setting.accessible_by(current_ability)
    end

    # GET /admin/settings/1
    def show; end

    # GET /admin/settings/1/edit
    def edit; end

    # PUT /admin/settings/1
    def update
      respond_to do |format|
        if @setting.update!(update_params)
          format.html { redirect_to admin_setting_path(@setting), notice: t(:updated) }
          format.json { render :show, status: :ok, location: admin_setting_path(@setting) }
        else
          format.html { render :edit }
          format.json { render json: @setting.errors, status: :unprocessable_entity }
        end
      end
    end

    private

    def update_params
      update_params = params.require(:setting).permit(:description, :value)
      merge_updated_by(update_params)
    end

    def set_setting
      @setting = Setting.accessible_by(current_ability).find(params[:id])
    end

    def authorize_user
      authorize! :edit, Setting
    end
  end
end
