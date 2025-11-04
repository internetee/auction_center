class RequestMetricsMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = ActionDispatch::Request.new(env)
    start_time = Time.current

    status, headers, response = @app.call(env)

    duration = Time.current - start_time

    controller = env['action_controller.instance']
    if controller
      tags = {
        method: request.method,
        status: status,
        controller: controller.controller_name,
        action: controller.action_name
      }

      Yabeda.auction.request_duration.measure(tags, duration)
      Yabeda.auction.requests_total.increment(tags)
    end

    [status, headers, response]
  end
end
