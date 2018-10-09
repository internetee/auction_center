class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user = User.new)
    @user = user
    user&.roles&.each { |role| send(role.to_sym) }
  end

  def participant
    can :manage, User, id: user.id
    can :manage, BillingProfile, user_id: user.id
  end

  def administrator
    can :manage, BillingProfile
    can :manage, User
    can %i[read update], Setting

    can :read, Audit::BillingProfile
    can :read, Audit::User
    can :read, Audit::Setting
  end
end
