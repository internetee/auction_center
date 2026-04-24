require 'test_helper'

class EmailTest < ActiveSupport::TestCase
  def test_check_fails_when_host_or_port_not_set
    Rails.application.config.action_mailer.smtp_settings[:address] = nil
    Rails.application.config.action_mailer.smtp_settings[:port] = nil

    checker = ApplicationHealthCheck::Email.new
    checker.check

    assert_not checker.success?
    assert_equal 'Mail server host or port not set', checker.message
  end

  def test_check_succeeds_when_port_is_open
    Rails.application.config.action_mailer.smtp_settings[:address] = 'smtp.example.test'
    Rails.application.config.action_mailer.smtp_settings[:port] = 25

    checker = ApplicationHealthCheck::Email.new
    checker.stub(:port_open?, true) do
      checker.check
    end

    assert checker.success?
    assert_equal 'Mail is up and running', checker.message
  end

  def test_check_fails_when_port_is_closed
    Rails.application.config.action_mailer.smtp_settings[:address] = 'smtp.example.test'
    Rails.application.config.action_mailer.smtp_settings[:port] = 25

    checker = ApplicationHealthCheck::Email.new
    checker.stub(:port_open?, false) do
      checker.check
    end

    assert_not checker.success?
    assert_equal 'Mail is offline', checker.message
  end
end
