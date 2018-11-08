require 'test_helper'

class AnonymousUserAbilityTest < ActiveSupport::TestCase
  def setup
    anonymous_user = User.new
    anonymous_user.roles = []

    @anonymous_ability = Ability.new(anonymous_user)
  end

  def test_anonymous_user_can_read_auctions
    assert(@anonymous_ability.can?(:read, Auction))
  end

  def test_anonymous_user_cannot_manage_offers
    refute(@anonymous_ability.can?(:read, Offer))
    refute(@anonymous_ability.can?(:create, Offer))
  end

  def test_anonymous_user_cannot_read_results
    refute(@anonymous_ability.can?(:read, Result.new))
  end
end
