require 'test_helper'

class AdminStatisticsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @admin = users(:administrator)
    @participant = users(:participant)
  end

  def test_index_renders_for_admin
    sign_in @admin
    fake_report = Object.new
    fake_report.define_singleton_method(:gather_data) { true }
    StatisticsReport::ATTRS.each do |attr|
      fake_report.define_singleton_method(attr) { {} }
    end

    StatisticsReport.stub(:new, fake_report) do
      get admin_statistics_path
    end

    assert_response :ok
  end

  def test_index_returns_not_found_for_non_admin
    sign_in @participant

    get admin_statistics_path

    assert_response :not_found
  end
end
