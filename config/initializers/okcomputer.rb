OkComputer.mount_at = false
OkComputer.check_in_parallel = true

OkComputer::Registry.register 'api', ApplicationHealthCheck::API.new
OkComputer::Registry.register 'registry', ApplicationHealthCheck::Registry.new
OkComputer::Registry.register 'tara', ApplicationHealthCheck::Tara.new
OkComputer::Registry.register 'email', ApplicationHealthCheck::Email.new
OkComputer::Registry.register 'sms', ApplicationHealthCheck::SMS.new
