module Auth
  class SessionsController < Devise::SessionsController
    include BansHelper
    after_action :set_ban_in_session, only: [:create]

    def create
      super
    end
  end
end
