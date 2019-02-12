class ResultStatusUpdateJob < ApplicationJob
  def perform
    Result.pending_status_report.map do |result|
      ResultStatusReporter.new(result).call
    end
  end

  def self.needs_to_run?
    registry_integration_enabled && Result.pending_status_report.any?
  end

  def self.registry_integration_enabled
    AuctionCenter::Application.config
                              .customization
                              .dig('registry_integration', 'enabled')
  end
end
