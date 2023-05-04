class NotificationsController < ApplicationController
  def index
    @notifications = current_user&.notifications.limit(6)
  end
end
