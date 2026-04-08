require 'test_helper'

class BankLinkVariantsTest < ActiveSupport::TestCase
  def test_bank_link_variants_have_expected_namespace_names
    assert_equal 'lhv', PaymentOrders::LHV.config_namespace_name
    assert_equal 'seb', PaymentOrders::SEB.config_namespace_name
    assert_equal 'swedbank', PaymentOrders::Swedbank.config_namespace_name
  end

  def test_bank_link_variants_inherit_from_estonian_bank_link
    assert PaymentOrders::LHV < PaymentOrders::EstonianBankLink
    assert PaymentOrders::SEB < PaymentOrders::EstonianBankLink
    assert PaymentOrders::Swedbank < PaymentOrders::EstonianBankLink
  end
end
