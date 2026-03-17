# frozen_string_literal: true

# Yabeda business metrics for monitoring critical endpoints performance
# Tracks InvoicesController#index and OffersController#index separately

Yabeda.configure do
  group :business do
    histogram :invoices_index_duration,
      comment: "Time to load invoices list page",
      unit: :seconds,
      tags: %i[status],
      buckets: [0.1, 0.3, 0.5, 1, 2, 5]

    histogram :offers_index_duration,
      comment: "Time to load user offers list page",
      unit: :seconds,
      tags: %i[status],
      buckets: [0.1, 0.3, 0.5, 1, 2, 5]
  end
end

# Hook into yabeda-rails controller action events
Yabeda::Rails.on_controller_action do |event, labels|
  if event.payload[:controller] == "InvoicesController" && event.payload[:action] == "index"
    Yabeda.business.invoices_index_duration.measure(
      { status: labels[:status] },
      event.payload[:view_runtime].to_f / 1000.0
    )
  end

  if event.payload[:controller] == "OffersController" && event.payload[:action] == "index"
    Yabeda.business.offers_index_duration.measure(
      { status: labels[:status] },
      event.payload[:view_runtime].to_f / 1000.0
    )
  end
end
