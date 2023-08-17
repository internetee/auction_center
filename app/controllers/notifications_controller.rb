class NotificationsController < ApplicationController
  def index
    @notifications = current_user&.notifications

    @unread_notifications = @notifications&.unread
    @read_notifications = @notifications&.read
  end
end
