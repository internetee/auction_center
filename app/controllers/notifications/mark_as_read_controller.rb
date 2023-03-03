class Notifications::MarkAsReadController < ApplicationController
  def update
    current_user&.notifications&.map(&:mark_as_read!)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [ 
          turbo_stream.update('bell-broadcast', partial: 'notifications/bell', locals: { any_unread: false }),
        ]
      end
    end
  end
end
