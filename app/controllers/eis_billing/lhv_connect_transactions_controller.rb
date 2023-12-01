# frozen_string_literal: true

module EisBilling
  class LHVConnectTransactionsController < EisBilling::BaseController
    MISSING_PARAMS = 'MISSING PARAMS'
    RECEIVED = 'RECEIVED'

    rescue_from LHVMissingParamsError, with: :render_missing_lhv_params_error
    before_action :check_for_params

    def create
      bank_statement = BankStatement.create(bank_code: Setting.find_by(code: 'auction_bank_code').retrieve,
                                            iban: Setting.find_by(code: 'auction_iban').retrieve)
      params['_json'].each { |incoming_transaction| bank_statement.process_lhv_transaction(incoming_transaction) }

      render status: :ok, json: { message: RECEIVED, params: }
    end

    private

    def render_missing_lhv_params_error(exception)
      render json: { title: MISSING_PARAMS, error: exception }, status: :not_found
    end

    def check_for_params
      return if params['_json'].present?

      raise LHVMissingParamsError, I18n.t('.lhv_missing_params_error')
    end
  end
end
