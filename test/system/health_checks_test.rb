require 'application_system_test_case'

class HealthChecksTest < ApplicationSystemTestCase
  def setup
    super
    @original_wait_time = Capybara.default_max_wait_time
    Capybara.default_max_wait_time = 10
  end
  
  def teardown
    super
    Capybara.default_max_wait_time = @original_wait_time
  end

  def test_visit_healthcheck_main
    visit healthcheck_path
    assert_text 'default'
  end

  def test_visit_healtcheck_default
    visit healthcheck_path
    assert_text 'default'
  end

  def test_visit_healthcheck_database
    visit healthcheck_path + '/database'
    assert_text 'database'
  end

  def test_visit_healthcheck_registry
    visit healthcheck_path + '/registry'
    assert_text 'registry'
  end

  def test_visit_healthcheck_tara
    visit healthcheck_path + '/tara'
    assert_text 'tara'
  end

  def test_visit_healthcheck_email
    visit healthcheck_path + '/email'
    assert_text 'email'
  end

  def test_visit_healthcheck_sms
    visit healthcheck_path + '/sms'
    assert_text 'sms'
  end
end