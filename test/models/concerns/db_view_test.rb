require 'test_helper'

class DbViewTest < ActiveSupport::TestCase

  def setup
    super
    @klass = StatisticsReport::Auction
    @klass.extend(DbView)
    @klass.refresh
    @object = StatisticsReport::Auction.first
  end

  def test_klass_responses
    assert(@klass.respond_to?(:refresh))
  end

  def test_instance_responses
    assert(@object.respond_to?(:readonly?))
  end

  def test_instance_readonly
    assert(@object.readonly?)
  end

  def test_primary_key
    assert_equal('id', @klass.primary_key)
  end

  def test_concern_included
    assert(@klass.included_modules.include?(DbView))
  end
end
