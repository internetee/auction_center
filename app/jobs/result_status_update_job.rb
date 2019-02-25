class ResultStatusUpdateJob < ApplicationJob
  def perform
    Result.pending_status_report.map do |result|
      Registry::StatusReporter.new(result).call
    end
  end

  def self.needs_to_run?
    registry_integration_enabled? && Result.pending_status_report.any?
  end

  def self.registry_integration_enabled?
    Feature.registry_integration_enabled?
  end
end
