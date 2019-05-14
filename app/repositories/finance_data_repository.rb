# frozen_string_literal: true

require 'exceptions/finance_data_validation_error'
require 'schemas/finance_data_schema'
require 'parsers/parse_finance_data'
require 'clients/finance_data_client'

class FinanceDataRepository
  def self.get(company_symbol)
    finance_data = ParseFinanceData.call(FinanceDataClient.get(company_symbol))
    validated = FinanceDataSchema.schema.call(finance_data)
    unless validated.errors.empty?
      LOGGER.error("Finance data validation failed with errors: #{validated.errors.to_json}")
      raise FinanceDataValidationError, 'Finance data validation failed'
    end
    validated.output
  end
end
