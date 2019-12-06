require 'countries'

module Admin
  class SettingsController < BaseController
    before_action :set_setting, except: :index
    before_action :authorize_user

    # GET /admin/settings
    def index
      @settings = ApplicationSetting.all
    end

    # GET /admin/settings/1
    def show; end

    # GET /admin/settings/1/edit
    def edit; end

    # PUT /admin/settings/1
    def update
      respond_to do |format|
        if @setting.test_update(update_params)
          format.html { redirect_to admin_setting_path(@setting.code), notice: t(:updated) }
          format.json { render :show, status: :ok, location: admin_setting_path(@setting.code) }
        else
          format.html { render :edit }
          format.json { render json: @setting.errors, status: :unprocessable_entity }
        end
      end
    end

    private

    def update_params
      update_params = params.require(:application_setting).permit(:description, :value)
      merge_updated_by(update_params)
    end

    def set_setting
      @setting = ApplicationSetting.find_by_code(params[:id])
    end

    def authorize_user
      authorize! :edit, Setting
    end
  end
end
