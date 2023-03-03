class Notification < ApplicationRecord
  include Noticed::Model
  belongs_to :recipient, polymorphic: true

  after_create_commit :broadcast_to_bell
  after_create_commit :broadcast_to_recipient

  after_create_commit :mobile_broadcast_to_bell
  after_create_commit :mobile_broadcast_to_recipient

  def broadcast_to_recipient
    broadcast_append_later_to(
      recipient,
      :notifications,
      target: 'notifications-list',
      partial: 'notifications/notification',
      locals: {
        notification: self
      }
    )
  end

  def broadcast_to_bell
    broadcast_update_later_to(
      recipient,
      :notifications,
      target: 'bell-broadcast',
      partial: 'notifications/bell',
      locals: {
        any_unread: true
      }
    )
  end

  def broadcast_to_bell
    broadcast_update_later_to(
      recipient,
      :notifications_mobile,
      target: 'bell-broadcast',
      partial: 'notifications/bell',
      locals: {
        any_unread: true
      }
    )
  end

  def mobile_broadcast_to_recipient
    broadcast_append_later_to(
      recipient,
      :notifications_mobile,
      target: 'notifications-list-mobile',
      partial: 'notifications/notification',
      locals: {
        notification: self
      }
    )
  end

  def mobile_broadcast_to_bell
    broadcast_update_later_to(
      recipient,
      :notifications_mobile,
      target: 'bell-broadcast-mobile',
      partial: 'notifications/bell',
      locals: {
        any_unread: true
      }
    )
  end
end
