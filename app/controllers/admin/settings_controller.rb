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
        if @setting.update(update_params)
          format.html { redirect_to admin_setting_path(@setting.code), notice: t(:updated) }
        else
          format.html { render :edit }
        end
      end
    end

    private

    def update_params
      update_params = params.require(:application_setting).permit(:code, :description, :value)
      merge_updated_by(update_params)
    end

    def set_setting
      @setting = ApplicationSetting.find_by(code: params[:id])
    end

    def authorize_user
      authorize! :edit, ApplicationSettingFormat
      authorize! :edit, Setting
    end
  end
end
