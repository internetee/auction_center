class NotificationChannel < ApplicationCable::Channel
  def subscribed
    # TODO

    # 1. indicate who subscribe
    # 2. indicate his locale
    # 3. transform incoming message to his locale

    stream_from "notification_channel_#{params[:user_id]}"

    
  end
end
