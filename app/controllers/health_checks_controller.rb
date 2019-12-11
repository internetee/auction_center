class HealthChecksController < ApplicationController

  def index
    @check_results = ApplicationHealthCheck::InternalCheck.new.run
  end
end
