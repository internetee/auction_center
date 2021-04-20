module Auth
  class SessionsController < Devise::SessionsController
    include InvalidUserDataHelper
    after_action :set_invalid_data_flag_in_session, only: [:create]

    def create
      super
    end
  end
end
