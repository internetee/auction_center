class NotificationsController < ApplicationController
  def index
    @notifications = current_user&.notifications
    @notifications.map(&:mark_as_read!)
  end

  def show; end

  def update; end
end
