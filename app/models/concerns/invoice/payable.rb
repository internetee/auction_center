# frozen_string_literal: true

module Invoice::Payable
  extend ActiveSupport::Concern

  included do
    scope :with_ban, -> { where(id: Ban.valid.pluck(:invoice_id)) }
    scope :without_ban, -> { where.not(id: Ban.valid.pluck(:invoice_id)) }
  end

  def payable?
    issued? || cancelled_and_have_valid_ban?
  end

  private

  def cancelled_and_have_valid_ban?
    cancelled? && Ban.valid.where(invoice_id: id).present?
  end
end

