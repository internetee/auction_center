module Admin
  class VersionsController < BaseController
    def index
      resource_class, @resource_id = request.path.split('/')[2, 2]
      @audit_class = ("Audit::" + resource_class.singularize.classify).constantize
      @items = @audit_class.where(object_id: @resource_id).order(recorded_at: :desc)
    end
  end
end
