require 'test_helper'

class ApiAuctionsListTest < ActionDispatch::IntegrationTest
  def setup
    super

    travel_to Time.parse('2010-07-05 10:30 +0000')
  end

  def teardown
    super

    travel_back
  end

  def test_can_get_a_list_of_current_auctions_as_json
    get(auctions_path, headers: { 'Accept': 'application/json' })
    response_json = JSON.parse(response.body)

    assert_equal(response_json.count, 4)

    response_json.each do |item|
      assert(item.has_key?('domain_name'))
      assert(item.has_key?('starts_at'))
      assert(item.has_key?('ends_at'))
    end

    expected_domains = ['with-offers.test', 'no-offers.test', 'with-invoice.test', 'orphaned.test']
    assert_equal(expected_domains.to_set, response_json.map { |e| e['domain_name'] }.to_set)
  end

  def test_cannot_get_a_list_of_current_auctions_as_xml
    assert_raises ActionController::UnknownFormat do
      get(auctions_path, headers: { 'Accept': 'application/xml' })
    end
  end
end
