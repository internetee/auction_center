class NotificationsController < ApplicationController
  before_action :authenticate_user!

  DEFAULT_PAGE_LIMIT = 15

  def index
    @notifications = current_user&.notifications

    @unread_pagy, @unread_notifications = pagy(@notifications&.unread, page_param: :unread_page, items: DEFAULT_PAGE_LIMIT)
    @read_pagy, @read_notifications = pagy(@notifications&.read, page_param: :read_page, items: DEFAULT_PAGE_LIMIT)
  end
end
