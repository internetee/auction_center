require 'test_helper'

class OrderableTest < ActiveSupport::TestCase
  def test_returns_an_empty_hash_when_not_valid
    orderable = Orderable.new('SomeModel', 'some_column', 'desc')

    assert_equal({}, orderable.hash)
  end

  def test_returns_the_default_when_not_valid_and_default_given
    orderable = Orderable.new('SomeModel', 'some_column', 'desc', {id: :desc})

    assert_equal({id: :desc}, orderable.hash)
  end

  def test_returns_order_hash_for_valid_conditions
    orderable = Orderable.new('Auction', 'domain_name', 'desc', {id: :desc})

    assert_equal({'domain_name' => 'desc'}, orderable.hash)
  end
end
