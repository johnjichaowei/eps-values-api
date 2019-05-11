# frozen_string_literal: true

require 'clients/finance_data_client'

RSpec.describe FinanceDataClient do
  subject(:get) { described_class.get(company_symbol) }

  let(:base_url) { 'http://dummy-site.com' }
  let(:company_symbol) { 'CBA' }
  let(:http) { instance_double(EM::HttpConnection) }
  let(:http_client) do
    instance_double(
      EM::HttpClient,
      error: error,
      response: response_body,
      response_header: response_header
    )
  end
  let(:error) { nil }
  let(:response_body) { 'bla' }
  let(:response_header) { instance_double(EM::HttpResponseHeader, status: response_status) }
  let(:response_status) { 200 }

  before do
    allow(ENVied).to receive(:FINANCE_DATA_HOST_URL).and_return(base_url)
    allow(EM::HttpRequest).to receive(:new).and_return(http)
    allow(http).to receive(:get).and_return(http_client)
  end

  it 'instantiates one EM::HttpRequest with the correct url' do
    expect(EM::HttpRequest).to receive(:new).with(
      "#{base_url}/quote/#{company_symbol}.AX"
    ).once
    get
  end

  it 'uses the EM::HttpConnection to send the get request' do
    expect(http).to receive(:get).once
    get
  end

  it 'returns the response body' do
    expect(get).to eq(response_body)
  end

  context 'when the response code is not 200' do
    let(:response_status) { 500 }

    it 'raises exception' do
      expect { get }.to raise_error(
        FinanceDataClientError,
        "Failed to retrieve finance data for #{company_symbol}, response code #{response_status}"
      )
    end
  end

  context 'when there is connection error' do
    let(:error) { 'Error happened' }

    it 'raises exception' do
      expect { get }.to raise_error(
        FinanceDataClientError,
        "Connection error when retrieving finance data for #{company_symbol}, error #{error}"
      )
    end
  end
end
