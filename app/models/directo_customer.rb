# frozen_string_literal: true

class DirectoCustomer < ApplicationRecord
  validates :vat_number, presence: true, uniqueness: true, case_sensitive: false
  validates :customer_code, uniqueness: true
  before_validation :generate_customer_code, :upcase_vat_number
  # before_save :capitalize_vat_number

  private

  def upcase_vat_number
    vat_number.strip!
    vat_number.upcase!
  end

  def generate_customer_code
    return if customer_code.present?

    self.customer_code = loop do
      number = rand(999_999...10_000_000)
      break number unless DirectoCustomer.exists?(customer_code: number)
    end
  end
end
