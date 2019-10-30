require 'test_helper'

class EmailTest < ActiveSupport::TestCase
  def test_port_check_success_if_stubbed
    host = 'smtp.gmail.com'
    port = '456'

    mock = Minitest::Mock.new
    mock.expect(:port_open?, true, [host, port])

    ApplicationHealthCheck::Email.stub(:new, mock) do
      checker = ApplicationHealthCheck::Email.new
      assert_equal(true, checker.port_open?(host, port))
    end
  end

  def test_checker_success_if_stubbed
    host = 'smtp.gmail.com'
    port = '456'
    message = 'Mail is up and running'
    Rails.application.config.action_mailer.smtp_settings[:address] = host
    Rails.application.config.action_mailer.smtp_settings[:port] = port

    mock = Minitest::Mock.new
    mock.expect(:message, message)
    mock.expect(:check, true)
    mock.expect(:port_open?, true)

    ApplicationHealthCheck::Email.stub(:new, mock) do
      checker = ApplicationHealthCheck::Email.new
      checker.check
      assert_equal(message, checker.message)
    end
  end

  def test_checker_fails_if_host_unreachable
    host = 'smtp.gmail.com'
    port = '456'
    message = 'Mail is offline'
    Rails.application.config.action_mailer.smtp_settings[:address] = host
    Rails.application.config.action_mailer.smtp_settings[:port] = port

    mock = Minitest::Mock.new
    mock.expect(:message, message)
    mock.expect(:check, true)
    mock.expect(:port_open?, false)

    ApplicationHealthCheck::Email.stub(:new, mock) do
      checker = ApplicationHealthCheck::Email.new
      checker.check
      assert_equal(message, checker.message)
    end
  end

  def test_checker_offline_if_not_stubbed
    Rails.application.config.action_mailer.smtp_settings[:address] = 'smtp.gmail.com'
    Rails.application.config.action_mailer.smtp_settings[:port] = '456'

    checker = ApplicationHealthCheck::Email.new
    checker.check

    assert(checker.message.present?)
    assert_equal('Mail is offline', checker.message)
  end

  def test_checker_fail
    Rails.application.config.action_mailer.smtp_settings[:address] = ''
    Rails.application.config.action_mailer.smtp_settings[:port] = ''

    checker = ApplicationHealthCheck::Email.new
    checker.check

    assert(checker.message.present?)
    assert_equal('Mail server host or port not set', checker.message)
  end
end
