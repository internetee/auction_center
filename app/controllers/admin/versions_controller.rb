module Admin
  class VersionsController < BaseController
    before_action :set_audit
    before_action :authorize_user

    def index
      @items = @audit_class.where(object_id: @resource_id).order(recorded_at: :desc)
      return unless @audit_class == ('Audit::' + 'ApplicationSettingFormat'.classify).constantize

      @items = @audit_class.where("new_value->>'settings' like '%\"#{@resource_id}\"%'")
                           .order(recorded_at: :desc)
      @items.each do |item|
        item.new_value = ApplicationSetting.new(item.new_value['settings'][@resource_id])
      end
    end

    private

    def set_audit
      resource_class, @resource_id = request.path.split('/')[2, 2]
      @audit_class = ('Audit::' + resource_class.singularize.classify).constantize
      return unless resource_class == 'settings'

      @audit_class = ('Audit::' + 'application_setting_formats'.singularize.classify).constantize
    end

    def authorize_user
      authorize! :read, @audit_class
    end
  end
end
