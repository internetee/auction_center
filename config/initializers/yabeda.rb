Yabeda.configure do
  group :auction do
    counter :home_page_total_views, comment: 'Total views of the home page'

    gauge :unique_bidders_daily,
          comment: 'Number of unique users who placed bids today',
          tags: [:date]
  end
end
