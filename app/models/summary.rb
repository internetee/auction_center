class Summary
  attr_reader :start_date
  attr_reader :end_date

  def initialize(start_date, end_date)
    @start_date = start_date
    @end_date = end_date
  end

  def results_with_no_bids
    @_results_with_no_bids = Result.where('created_at > ? and created_at < ?', start_date, end_date)
                                   .count
  end
end
