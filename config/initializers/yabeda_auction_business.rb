# frozen_string_literal: true

# Yabeda business metrics for auctions and offers
# Tracks active auctions, offer creation, and failures

Yabeda.configure do
  group :auction_business do
    gauge :active_auctions_total,
      comment: "Current number of active auctions",
      tags: %i[platform]

    counter :offers_created_total,
      comment: "Total created offers/bids",
      tags: %i[platform]

    counter :offers_failed_total,
      comment: "Failed offer creation attempts",
      tags: %i[reason platform]
  end
end
