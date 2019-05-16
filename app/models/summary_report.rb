class SummaryReport
  attr_reader :start_time
  attr_reader :end_time

  def initialize(start_time, end_time)
    @start_time = start_time
    @end_time = end_time
  end

  def gather_data
    winning_offers
    results_with_no_bids
    registration_deadlines
    bans
  end

  # Returns an array of hashes:
  # [{'domain_name' => 'foo.test', 'cents' => 4000},
  #  {'domain_name' => 'bar.test', 'cents' => 2000}]
  def winning_offers
    sql = <<~SQL
      SELECT auctions.domain_name,
             offers.cents,
             results.id result_id
      FROM auctions, offers, results
      WHERE offers.auction_id = auctions.id
        AND offers.id = results.offer_id
        AND results.status <> ?
        AND results.created_at > ?
        AND results.created_at < ?
      ORDER BY offers.cents DESC
    SQL

    interpolated = ActiveRecord::Base.sanitize_sql([sql, Result.statuses[:no_bids],
                                                    start_time, end_time])
    @winning_offers ||= ActiveRecord::Base.connection.execute(interpolated).to_a
  end

  # Returns an array of hashes:
  # [{'domain_name' => 'foo.test', 'status' => 'no_bids'},
  #  {'domain_name' => 'bar.test', 'status' => 'no_bids'}]
  def results_with_no_bids
    sql = <<~SQL
      SELECT auctions.domain_name,
             results.status
      FROM auctions, results
      WHERE results.auction_id = auctions.id
        AND results.offer_id IS NULL
        AND results.status = ?
        AND results.created_at > ?
        AND results.created_at < ?
    SQL

    interpolated = ActiveRecord::Base.sanitize_sql([sql, Result.statuses[:no_bids],
                                                    start_time, end_time])
    @results_with_no_bids ||= ActiveRecord::Base.connection.execute(interpolated).to_a
  end

  # Returns an array of hashes:
  # [{'domain_name' => 'foo.test', 'email' => 'foo@bar.baz', 'mobile_phone' => '+37255556666'},
  #  {'domain_name' => 'bar.test', 'email' => 'bar@foo.baz', 'mobile_phone' => nil}]
  def registration_deadlines
    sql = <<~SQL
      SELECT auctions.domain_name,
             users.email,
             users.mobile_phone,
             results.id result_id
      FROM auctions, users, results
      WHERE results.auction_id = auctions.id
        AND users.id = results.user_id
        AND results.status = ?
        AND results.registration_due_date = ?
    SQL

    interpolated = ActiveRecord::Base.sanitize_sql([sql, Result.statuses[:payment_received],
                                                   Time.zone.today + 1])
    @registration_deadlines ||= ActiveRecord::Base.connection.execute(interpolated).to_a
  end

  # Returns an array of hashes
  # [{'domain_name' => 'foo.bar', 'valid_until' => '2019-05-15 21:00:00', 'email' => 'foo@bar.baz'},
  #  {'domain_name' => nil, 'valid_until' => '2019-05-15 21:00:00', 'email' => 'foo@bar.baz'},]
  def bans
    sql = <<~SQL
      SELECT bans.domain_name,
             bans.valid_until,
             users.email
      FROM bans, users
      WHERE bans.user_id = users.id
        AND bans.created_at > ?
        AND bans.created_at < ?
    SQL

    interpolated = ActiveRecord::Base.sanitize_sql([sql, start_time, end_time])
    @bans ||= ActiveRecord::Base.connection.execute(interpolated).to_a
  end
end
