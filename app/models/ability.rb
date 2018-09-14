class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user = User.new)
    @user = user
    user&.roles&.each { |role| send(role.to_sym) }
  end

  def participant
    can :manage, User, id: user.id
  end

  def administrator
    can :manage, User
  end
end
