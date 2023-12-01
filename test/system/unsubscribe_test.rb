require 'application_system_test_case'

class UnsubscribeTest < ApplicationSystemTestCase
  def setup
    @participant = users(:participant)
    @unsubscribe = Rails.application.message_verifier(:unsubscribe).generate(@participant.id)

    stub_request(:post, "http://eis_billing_system:3000/api/v1/invoice_generator/reference_number_generator").
      to_return(status: 200, body: "{\"reference_number\":\"12332\"}", headers: {})
  end

  def test_unsubscribe_user
    @participant.daily_summary = true
    @participant.save

    assert_equal(@participant.daily_summary, true)

    visit(unsubscribe_unsubscribe_url(id: @unsubscribe))
    assert_text 'Please confirm that you no longer wish to receive daily summary'

    click_link_or_button('Unsubscribe')
    assert_text 'Subscription Cancelled'

    @participant.reload
    assert_equal(@participant.daily_summary, false)
  end
end
