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

  def test_cors_preflight_check
    # OPTIONS /auctions
    process(:options, auctions_path, headers: { 'Origin' => 'https://example.com' })
    assert_equal('https://example.com', response.headers['Access-Control-Allow-Origin'])
    assert_equal('GET, OPTIONS', response.headers['Access-Control-Allow-Methods'])
    assert_equal('Origin, Content-Type, Accept, Authorization, Token, Auth-Token, Email, ' \
                 'X-User-Token, X-User-Email',
               response.headers['Access-Control-Allow-Headers'])
    assert_equal('3600', response.headers['Access-Control-Max-Age'])

    # OPTIONS /auctions.json
    process(:options, '/auctions.json', headers: { 'Origin' => 'https://example.com' })
    assert_equal('https://example.com', response.headers['Access-Control-Allow-Origin'])
    assert_equal('GET, OPTIONS', response.headers['Access-Control-Allow-Methods'])
    assert_equal('Origin, Content-Type, Accept, Authorization, Token, Auth-Token, Email, ' \
                 'X-User-Token, X-User-Email',
               response.headers['Access-Control-Allow-Headers'])
    assert_equal('3600', response.headers['Access-Control-Max-Age'])

    # GET /auctions
    get auctions_path, headers: { 'Origin' => 'https://example.com', 'Accept' => 'application/json' }
    assert_equal('https://example.com', response.headers['Access-Control-Allow-Origin'])
  end

  def test_can_get_a_list_of_current_auctions_as_json
    get(auctions_path, headers: { 'Accept': 'application/json' })
    response_json = JSON.parse(response.body)

    assert_equal(response_json.count, 4)

    response_json.each do |item|
      assert(item.has_key?('domain_name'))
      assert(item.has_key?('starts_at'))
      assert(item.has_key?('ends_at'))
      assert(item.has_key?('id'))
    end

    expected_domains = ['with-offers.test', 'no-offers.test', 'with-invoice.test',
                        'orphaned123.test']
    assert_equal(expected_domains.to_set, response_json.map { |e| e['domain_name'] }.to_set)
  end

  def test_cannot_get_a_list_of_current_auctions_as_xml
    assert_raises ActionController::UnknownFormat do
      get(auctions_path, headers: { 'Accept': 'application/xml' })
    end
  end
end
