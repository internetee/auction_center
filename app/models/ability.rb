class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user = User.new)
    @user = user
    anonymous_user
    user&.roles&.each { |role| send(role.to_sym) }
  end

  def anonymous_user
    can :read, Auction
  end

  def participant
    can :manage, User, id: user.id
    can :manage, BillingProfile, user_id: user.id
    can :manage, Offer, user_id: user.id
  end

  def administrator
    can :manage, Auction
    can :manage, BillingProfile
    can :manage, User
    can %i[read update], Setting
    can :read, Offer

    can :read, Audit::Auction
    can :read, Audit::BillingProfile
    can :read, Audit::User
    can :read, Audit::Setting
  end
end
