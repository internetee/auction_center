# config/initializers/request_logger.rb
class RequestLogger
  def initialize(app)
    @app = app
  end

  def call(env)
    start = Time.current
    Rails.logger.info "Request started: #{env['REQUEST_METHOD']} #{env['PATH_INFO']}"
    Rails.logger.info "Query string: #{env['QUERY_STRING']}"
    Rails.logger.info "Remote IP: #{env['REMOTE_ADDR']}"
    Rails.logger.info "User Agent: #{env['HTTP_USER_AGENT']}"
    
    status, headers, response = @app.call(env)
    
    Rails.logger.info "Request finished in #{Time.current - start}s with status #{status}"
    
    [status, headers, response]
  end
end

Rails.application.config.middleware.insert_before 0, RequestLogger
