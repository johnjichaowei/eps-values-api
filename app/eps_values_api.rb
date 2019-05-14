# frozen_string_literal: true

require_relative '../system/boot'
require 'services/finance_data_service'
require 'exceptions/query_params_invalid_error'
require 'goliath'
require 'cgi'

class EpsValuesApi < Goliath::API
  def response(env)
    return [405, {}, 'Method not allowed'] if env[Goliath::Env::REQUEST_METHOD] != 'GET'
    return [404, {}, 'Not found'] if env[Goliath::Env::REQUEST_PATH] != '/eps_values'

    companies = parse_params(env[Goliath::Env::QUERY_STRING])
    [200, {}, FinanceDataService.get(companies).to_json]
  rescue QueryParamInvalidError => e
    [400, {}, e.message]
  end

  def parse_params(query_string)
    params = CGI.parse(query_string)
    companies = params['companies'][0]&.split(',')
    raise QueryParamInvalidError, 'The companies parameter is required' if params['companies'].count.zero?

    companies
  end
end
