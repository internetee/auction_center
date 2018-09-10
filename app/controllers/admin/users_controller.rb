module Admin
  class UsersController < BaseController
    load_and_authorize_resource

    # GET /admin/users
    def index
      @users = User.all
    end
  end
end
