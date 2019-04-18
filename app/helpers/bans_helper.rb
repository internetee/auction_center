module BansHelper
  # If current user has valid Bans applied at the moment, assign auction.bans
  # session key to the following data structure:
  # [array_of_domain_name, valid_until]
  # This can take two forms:
  #
  # [['domain.test', 'other_domain'], nil] is applicable for many small bans
  #
  # [nil, 2019-04-18 08:10:36 +0000] is applicable the automatic ban after many
  # offences or one applied manually from the admin interface.
  def set_ban_in_session
    return unless current_user

    bans = Ban.valid.where(user: current_user.id).order(valid_until: :desc)
    return unless bans

    session['auction.bans'] = if (complete_ban = bans.detect { |e| !e.domain_name })
                                [nil, complete_ban.valid_until]
                              else
                                [bans.map(&:domain_name), nil]
                              end
  end
end
