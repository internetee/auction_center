require 'test_helper'
require 'countries'

class CountriesTest < ActiveSupport::TestCase
  def test_name_from_country_code
    assert_equal('United Kingdom', Countries.name_from_alpha2_code('GB'))
    assert_nil(Countries.name_from_alpha2_code('GBSS'))
  end

  def test_alpha2_code_from_name
    assert_equal('GB', Countries.alpha2_code_from_name('United Kingdom'))
  end
end
