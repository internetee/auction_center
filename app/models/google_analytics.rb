class GoogleAnalytics
  attr_reader :tracking_id

  def initialize(tracking_id:)
    @tracking_id = tracking_id
  end

  def enabled?
    tracking_id.present?
  end
end
