class Api::V1::ApiHealthcareController < ApplicationController
  respond_to :json

  def index
    return render json: { message: 'API is turned off' }, status: 403 unless Feature.mobile_api_enabled?

    app_version = request.headers['App-Version']
    min_version = Feature.minimum_mobile_version

    if app_version.blank?
      return render json: {
        message: 'App version required',
        required_update: true
      }, status: 426 # Upgrade Required
    end

    if version_outdated?(app_version, min_version)
      return render json: {
        message: 'App update required',
        required_update: true,
        min_version:,
        current_version: app_version
      }, status: 426 # Upgrade Required
    end

    render json: {
      message: 'API is healthy',
      current_version: app_version
    }
  end

  private

  def version_outdated?(current, minimum)
    Gem::Version.new(current) < Gem::Version.new(minimum)
  end
end
