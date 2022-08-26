module EisBilling
  class DirectoResponseController < EisBilling::BaseController
    def update
      response = params[:response]
      xml_data = params[:xml_data]
      @month = params.fetch(:month, false)

      process_directo_response(xml_data, response)

      render status: :ok, json: { messege: 'Should return new directo number' }
    end

    private

    def process_directo_response(xml, response)
      Rails.logger.info "[Directo] - Responded with body: #{xml}"

      logger.info "Directo responded with body: #{xml}"

      pushed_invoices = []
      Nokogiri::XML(response).css('Result').each do |result|
        inv_no = result.attributes['docid'].value.to_i

        (pushed_invoices << inv_no) if invoice_reported_as_valid?(result)
      end
      mark_invoices_as_synced(invoice_ids: pushed_invoices)
    end

    def mark_invoices_as_synced(invoice_ids:)
      ::Invoice.where(number: invoice_ids).update(in_directo: true)
      logger.info "Marked #{invoice_ids.count} invoices as synced to directo"
    end

    def invoice_reported_as_valid?(result)
      inv_no = result.attributes['docid'].value.to_i
      result_type = result.attributes['Type'].value.to_i
      result_desc = result.attributes['Desc'].value
      (return true) if result_type.zero?

      logger.info "Not marking invoice ##{inv_no} as sent. Desc: #{result_desc}"
      false
    end
  end
end
