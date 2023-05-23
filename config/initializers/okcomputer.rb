require_relative '../../app/models/concerns/http_requester'
require_relative '../../app/models/concerns/health_checker'
require_relative '../../app/models/application_health_check/registry'
require_relative '../../app/models/application_health_check/tara'
require_relative '../../app/models/application_health_check/email'
require_relative '../../app/models/application_health_check/sms'

OkComputer.mount_at = false
OkComputer.check_in_parallel = true

OkComputer::Registry.register 'registry', ApplicationHealthCheck::Registry.new
OkComputer::Registry.register 'tara', ApplicationHealthCheck::Tara.new
OkComputer::Registry.register 'email', ApplicationHealthCheck::Email.new
OkComputer::Registry.register 'sms', ApplicationHealthCheck::Sms.new
