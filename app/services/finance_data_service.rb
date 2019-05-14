# frozen_string_literal: true

require 'em-synchrony'
require 'em-synchrony/fiber_iterator'
require 'repositories/finance_data_repository'

class FinanceDataService
  class << self
    def get(companies)
      results = {}
      EM::S::FiberIterator.new(companies, ENVied.MAX_CONCURRENCY_COUNT).each do |company|
        LOGGER.info("Retrieving finance data for #{company}")
        data = FinanceDataRepository.get(company)
        LOGGER.info("Finance data retrieved for #{company}, data: #{data}")
        results[company] = data
      end
      results
    end
  end
end
