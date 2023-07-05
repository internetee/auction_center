module ApplicationHealthCheck
  class Email < OkComputer::Check
    include HealthChecker

    def check
      if host.present? && port.present?
        check_smtp(host: host, port: port.to_i)
      else
        report_failure('Mail server host or port not set')
      end
    end

    private

    def check_smtp(host:, port:)
      if port_open?(host: host, port: port)
        mark_message('Mail is up and running')
      else
        report_failure('Mail is offline')
      end
    end

    def host
      Rails.application.config.action_mailer.smtp_settings[:address]
    end

    def port
      Rails.application.config.action_mailer.smtp_settings[:port]
    end

    def port_open?(host:, port:, seconds: 1)
      Timeout.timeout(seconds) do
        TCPSocket.new(host, port).close
        true
      rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, SocketError, Errno::EADDRNOTAVAIL
        false
      end
    rescue Timeout::Error
      false
    end
  end
end
