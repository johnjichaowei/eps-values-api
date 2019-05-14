# frozen_string_literal: true

require 'em-synchrony'
require 'em-synchrony/em-http'
require 'exceptions/finance_data_client_error'

class FinanceDataClient
  class << self
    def get(company_symbol)
      http = EM::HttpRequest.new("#{ENVied.FINANCE_DATA_HOST_URL}/quote/#{company_symbol}.AX").get

      conn_err = "Connection error when retrieving finance data for #{company_symbol}, error #{http.error}"
      raise FinanceDataClientError, conn_err if http.error

      return http.response if http.response_header.status == 200

      err_msg = "Failed to retrieve finance data for #{company_symbol}, response code #{http.response_header.status}"
      raise FinanceDataClientError, err_msg
    end
  end
end
