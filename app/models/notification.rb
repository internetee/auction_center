class Notification < ApplicationRecord
  include Noticed::Model
  belongs_to :recipient, polymorphic: true

  after_create_commit :broadcast_to_bell
  # after_update :broadcast_to_bell_mark_as_read
  after_create_commit :broadcast_to_recipient

  def broadcast_to_recipient
    broadcast_append_to(
      recipient,
      :notifications,
      target: 'notifications-list',
      partial: 'notifications/notification',
      locals: {
        notification: self
      }
    )
  end

  def broadcast_to_bell_mark_as_read
    broadcast_replace_later_to(
      recipient,
      :notifications,
      target: 'bell-broadcast',
      partial: 'notifications/bell',
      locals: {
        any_unread: nil
      }
    )
  end

  def broadcast_to_bell
    broadcast_replace_later_to(
      recipient,
      :notifications,
      target: 'bell-broadcast',
      partial: 'notifications/bell',
      locals: {
        any_unread: true
      }
    )
  end
end
