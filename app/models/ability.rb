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
    can :manage, BillingProfile, user_id: user.id
    can %i[read update], Invoice
    can :manage, Offer, user_id: user.id
    can %i[read create], PaymentOrder, user_id: user.id
    can :manage, PhoneConfirmation do |phone_confirmation|
      user.id == phone_confirmation.user.id
    end
    can :read, Result, user_id: user.id
    can :manage, User, id: user.id

    if banned?
      restrictions_from_bans
    end
  end

  def banned?
    Ban.valid.where(user_id: user.id).any?
  end

  def restrictions_from_bans
    cannot :destroy, User
    cannot [:manage], Offer do |offer|
      Ban.valid
         .where(user_id: user.id)
         .where("domain_name IS NULL OR domain_name = ?", offer.auction.domain_name)
         .any?
    end
  end

  def administrator
    can :manage, Auction
    can :manage, BillingProfile
    can :read, Invoice
    can :read, InvoiceItem
    can %i[read create], Job
    can :manage, User
    can %i[read update], Setting
    can :read, Offer
    can :read, Result
    can :read, PaymentOrder
    can :manage, PhoneConfirmation do |phone_confirmation|
      user.id == phone_confirmation.user.id
    end

    can :read, Audit::Auction
    can :read, Audit::BillingProfile
    can :read, Audit::Ban
    can :read, Audit::Invoice
    can :read, Audit::InvoiceItem
    can :read, Audit::User
    can :read, Audit::Offer
    can :read, Audit::Setting
    can :read, Audit::Result
    can :read, Audit::PaymentOrder
  end
end
