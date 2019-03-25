OkComputer.mount_at = false
OkComputer.require_authentication(
  ENV['HEALTHCHECK_USER'],
  ENV['HEALTHCHECK_PASSWORD'],
)
