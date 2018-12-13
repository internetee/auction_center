module Admin
  class VersionsController < BaseController
    before_action :set_audit
    before_action :authorize_user

    def index
      @items = @audit_class.where(object_id: @resource_id).order(recorded_at: :desc)
    end

    private

    def set_audit
      resource_class, @resource_id = request.path.split('/')[2, 2]
      @audit_class = ('Audit::' + resource_class.singularize.classify).constantize
    end

    def authorize_user
      authorize! :read, @audit_class
    end
  end
end
