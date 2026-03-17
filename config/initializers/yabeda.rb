Yabeda.configure do
  group :auction do
    counter :home_page_total_views, comment: 'Total views of the home page'
    counter :unique_bidders_total,
            comment: 'Total number of unique users who have ever placed bids'
  end
  
  group :db do
    histogram :query_duration,
      comment: "Database query duration",
      unit: :seconds,
      tags: [:sql_type],
      buckets: [0.001, 0.005, 0.01, 0.05, 0.1, 0.5, 1, 5]
  end

  group :eis_billing do
    counter :payment_failures_total,
      comment: 'Total payment failures from EIS Billing provider',
      tags: [:service, :error_type, :exception_class]
  end
end

ActiveSupport::Notifications.subscribe('sql.active_record') do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  next if event.payload[:name] == 'SCHEMA'
  
  Yabeda.db.query_duration.measure(
    { sql_type: event.payload[:sql]&.split&.first || 'unknown' },
    event.duration / 1000.0
  )
end