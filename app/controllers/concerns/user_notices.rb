module Concerns
  module UserNotices
    extend ActiveSupport::Concern

    def notification_for_delete(user)
      if user.deletable?
        t('.deleted')
      else
        t('.cannot_delete')
      end
    end

    def notification_for_update(email_changed)
      email_changed ? t('.email_changed') : t(:updated)
    end
  end
end
