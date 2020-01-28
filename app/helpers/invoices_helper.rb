module InvoicesHelper
  def fetch_errors_from_response(channel:, response:)
    return t('payment_orders.responses.empty_response') if response.nil?

    case channel
    when 'EveryPay'
      return 'OK' if response['transaction_result'] == 'completed'

      fetch_everypay_errors(response)
    when 'SEB', 'LHV', 'Swedbank'
      fetch_banklink_errors(response)
    end
  end

  def fetch_everypay_errors(response)
    elements = ''
    elements << content_tag(:a, "transaction: #{response['transaction_result']}",
                            class: 'ui label')
    elements << content_tag(:a, "payment: #{response['payment_state']}",
                            class: 'ui label')

    return simple_format(elements) unless response.key?('processing_errors')

    response['processing_errors'].each do |err|
      elements << content_tag(:a, err['message'], class: 'ui label')
    end
    simple_format(elements)
  end

  def fetch_banklink_errors(response)
    return 'OK' if response['VK_SERVICE'] == '1111'

    simple_format(content_tag(
                    :a, t('payment_orders.responses.bank_failed_code',
                          code: response['VK_SERVICE']),
                    class: 'ui label'
                  ))
  end
end
