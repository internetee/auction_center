require 'result_not_found'
require 'result_not_sold'

class Invoice < ApplicationRecord
  belongs_to :result, required: true
  belongs_to :user, required: false
  belongs_to :billing_profile, required: true

  validate :user_id_must_be_the_same_as_on_billing_profile_or_nil

  def self.create_from_result(result_id)
    result = Result.find_by(id: result_id)

    raise(Errors::ResultNotFound, result_id) unless result
    raise(Errors::ResultNotSold, result_id) unless result.sold?

    InvoiceCreator.new(result_id).call
  end

  def user_id_must_be_the_same_as_on_billing_profile_or_nil
    return unless billing_profile
    return if billing_profile.user_id == user_id
    return unless user_id

    errors.add(:billing_profile, I18n.t('invoices.billing_profile_must_belong_to_user'))
  end

  def price
    Money.new(cents, Setting.auction_currency)
  end
end
