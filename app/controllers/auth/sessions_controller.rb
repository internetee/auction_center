module Auth
  class SessionsController < Devise::SessionsController
    include RackSessionFix
    include InvalidUserDataHelper

    after_action :set_invalid_data_flag_in_session, only: [:create]

    skip_before_action :verify_authenticity_token
    respond_to :html, :json

    def create
      super
    end
  end
end
