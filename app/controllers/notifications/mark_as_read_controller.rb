class Notifications::MarkAsReadController < ApplicationController
  def update
    current_user&.notifications&.unread&.map(&:mark_as_read!)

    flash[:notice] = 'All notifications marked as read'
    redirect_to notifications_path, status: :see_other

    # respond_to do |format|
    #   format.turbo_stream do
    #     render turbo_stream: [ 
    #       turbo_stream.update('bell-broadcast', partial: 'notifications/bell', locals: { any_unread: false }),
    #     ]
    #   end
    # end
  end
end
