require 'test_helper'

class DirectoCustomerTest < ActiveSupport::TestCase
  def test_can_not_add_vat_number_duplicate
    directo_customer = DirectoCustomer.new
    directo_customer.vat_number = 123
    directo_customer.save
    assert directo_customer.valid?

    directo_customer = DirectoCustomer.new
    directo_customer.vat_number = 123
    assert_not directo_customer.valid?
  end

  def test_can_not_add_customer_code_duplicate
    directo_customer = DirectoCustomer.new
    directo_customer.vat_number = 123
    directo_customer.customer_code = 123
    directo_customer.save
    assert directo_customer.valid?

    directo_customer = DirectoCustomer.new
    directo_customer.vat_number = 456
    directo_customer.customer_code = 123
    assert_not directo_customer.valid?
  end

  def test_vat_number_is_case_insensitive
    directo_customer = DirectoCustomer.new
    directo_customer.vat_number = 'EE123'
    directo_customer.customer_code = 123
    directo_customer.save
    assert directo_customer.valid?

    directo_customer = DirectoCustomer.new
    directo_customer.vat_number = 'ee123'
    directo_customer.customer_code = 1234
    assert_not directo_customer.valid?
  end
end
