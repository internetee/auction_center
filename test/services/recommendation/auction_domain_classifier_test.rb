require 'test_helper'

module Recommendation
  class AuctionDomainClassifierTest < ActiveSupport::TestCase
    def setup
      super
      @auction = auctions(:valid_without_offers)
      @openai_model = Setting.find_by(code: 'openai_model')
    end

    def test_classifies_auction_domains_with_openai_response
      @openai_model.update!(value: 'gpt-3.5-turbo')

      stub_request(:post, 'https://api.openai.com/v1/chat/completions')
        .to_return_json(status: 200, body: ai_response, headers: {})

      result = AuctionDomainClassifier.call(auctions: [@auction])

      @auction.reload

      assert_equal 1, result.size
      assert_equal %w[shop_brand brandable], @auction.classification_tags
      assert_equal 'shop_brand', @auction.primary_category
      assert_equal 'openai', @auction.classification_source
      assert_equal 'gpt-5', @auction.classification_model
      assert @auction.classified?
    end

    private

    def ai_response
      {
        'choices' => [{
          'message' => {
            'content' => {
              classifications: [
                {
                  id: @auction.id,
                  domain_name: @auction.domain_name,
                  primary_category: 'shop_brand',
                  tags: %w[shop_brand brandable]
                }
              ]
            }.to_json
          }
        }]
      }
    end
  end
end
