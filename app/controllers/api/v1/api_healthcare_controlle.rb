class Api::V1::ApiHealthcareController < ApplicationController
  def index
    if Feature.mobile_api_enabled?
      render json: { message: 'API is healthy' }
    else
      render json: { message: 'API is turned off' }, status: 403
    end
  end
end
