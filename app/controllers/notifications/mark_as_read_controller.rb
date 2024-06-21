# frozen_string_literal: true

module Notifications
  class MarkAsReadController < ApplicationController
    def update
      current_user&.notifications&.unread&.each(&:mark_as_read!)

      flash[:notice] = t('notifications.all_marked_as_read')
      redirect_to notifications_path, status: :see_other
    end
  end
end
