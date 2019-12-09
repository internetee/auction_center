require 'test_helper'

class DBViewTest < ActiveSupport::TestCase

  def setup
    super
    @klass = StatisticsReport::Auction
    @klass.extend(Concerns::DBView)
    @klass.refresh
    @object = StatisticsReport::Auction.first
  end

  def test_klass_responses
    assert(@klass.respond_to?(:refresh))
  end

  def test_instance_responses
    assert(@object.respond_to?(:readonly?))
  end
end
