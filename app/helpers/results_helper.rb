module ResultsHelper
  def registration_code_or_information(result)
    case result.status
    when Result.statuses[:payment_received]
      @result.registration_code
    when Result.statuses[:domain_registered]
      t('.domain_already_registered')
    else
      t('.only_available_after_paying_invoice')
    end
  end

  def pay_invoice_before(result)
    if result.payment_received?
      t('.paid')
    elsif result&.invoice
      result.invoice.due_date
    else
      t('invoices.is_being_generated')
    end
  end
end
