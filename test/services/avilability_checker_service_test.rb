require 'test_helper'

class AvilabilityCheckerServiceTest < ActiveSupport::TestCase
  setup do
    not_available = { body: [{
      avail: 1
      }]
    }
    stub_request(:get, "http://registry:3000/api/v1/auctions/avilability_check?domain_name=not_available.ee")
      .to_return(status: 200, body: not_available.to_json, headers: {})

    available = { body: [{
      avail: 0
      }]
    }
    stub_request(:get, "http://registry:3000/api/v1/auctions/avilability_check?domain_name=available.ee")
      .to_return(status: 200, body: available.to_json, headers: {})
  end

  def test_should_return_false_if_not_available
    response = AvilabilityCheckerService.call(domain_name: 'not_available.ee')
    refute response
  end

  def test_should_return_false_if_available
    response = AvilabilityCheckerService.call(domain_name: 'available.ee')
    assert response
  end
end
