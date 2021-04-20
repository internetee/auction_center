module Concerns
  module Bannable
    extend ActiveSupport::Concern

    def current_bans
      bans = Ban.valid.where(user_id: id).order(valid_until: :desc)
      [bans.map(&:domain_name), longest_ban&.valid_until] if bans.present?
    end
  end
end
