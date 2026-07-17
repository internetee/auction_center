require 'test_helper'

class ApplicationServiceTest < ActiveSupport::TestCase
  class DummyService < ApplicationService
    def initialize(value)
      @value = value
    end

    def call
      @value
    end
  end

  def test_call_instantiates_and_calls
    assert_equal 123, DummyService.call(123)
  end
end
