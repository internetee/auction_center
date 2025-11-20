# frozen_string_literal: true

# Yabeda metrics for email infrastructure
# Tracks sent emails and failures

Yabeda.configure do
  group :mailers do
    counter :emails_sent_total,
      comment: "Sent emails",
      tags: %i[mailer action]

    counter :emails_failures_total,
      comment: "Email sending failures",
      tags: %i[mailer action exception_class]
  end
end

# Subscribe to Action Mailer delivery events
ActiveSupport::Notifications.subscribe "deliver.action_mailer" do |*args|
  event = ActiveSupport::Notifications::Event.new(*args)
  mailer = event.payload[:mailer]
  action = event.payload[:action]

  Yabeda.mailers.emails_sent_total.increment(mailer: mailer, action: action)
end
