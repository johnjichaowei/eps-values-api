# frozen_string_literal: true

require 'eps_values_api'

RSpec.describe EpsValuesApi do
  subject(:response) { described_class.new.response(env) }

  let(:env) { instance_double(Goliath::Env) }
  let(:request_method) { 'GET' }
  let(:request_path) { '/eps_values' }
  let(:query_string) { 'companies=RCA%2CREA%2CCBA' }
  let(:eps_values) { { foo: 'bar' } }
  let(:response_code) { 200 }
  let(:response_body) { eps_values.to_json }
  let(:expected_response) { [response_code, {}, response_body] }

  before do
    allow(env).to receive(:[]).with(Goliath::Env::REQUEST_METHOD).and_return(request_method)
    allow(env).to receive(:[]).with(Goliath::Env::REQUEST_PATH).and_return(request_path)
    allow(env).to receive(:[]).with(Goliath::Env::QUERY_STRING).and_return(query_string)
    allow(FinanceDataService).to receive(:get).and_return(eps_values)
  end

  it 'calls finance data service to retrieve eps values' do
    expect(FinanceDataService).to receive(:get).with(%w[RCA REA CBA]).once
    response
  end

  it 'returns expected response' do
    expect(response).to eq(expected_response)
  end

  context 'when request method is not GET' do
    let(:request_method) { 'POST' }
    let(:response_code) { 405 }
    let(:response_body) { 'Method not allowed' }

    it 'returns 404 Not found' do
      expect(response).to eq(expected_response)
    end
  end

  context 'when request path is invalid' do
    let(:request_path) { '/bla' }
    let(:response_code) { 404 }
    let(:response_body) { 'Not found' }

    it 'returns 404 Not found' do
      expect(response).to eq(expected_response)
    end
  end

  context 'when the companies param is missed' do
    let(:query_string) { 'a=b&c=d' }
    let(:response_code) { 400 }
    let(:response_body) { 'The companies parameter is required' }

    it 'returns 400 with a specific error reason' do
      expect(response).to eq(expected_response)
    end
  end
end
