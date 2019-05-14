# frozen_string_literal: true

require 'services/finance_data_service'

RSpec.describe FinanceDataService do
  subject(:get) do
    EM.synchrony do
      described_class.get(companies)
      EM.stop
    end
  end

  let(:company_symbol1) { 'CBA' }
  let(:company_symbol2) { 'REA' }
  let(:companies) { [company_symbol1, company_symbol2] }
  let(:finance_data1) { { eps_ttm: BigDecimal('2.12') } }
  let(:finance_data2) { { eps_ttm: BigDecimal('3.11') } }
  let(:concurrency_count) { 3 }
  let(:expected_result) do
    {
      company_symbol1 => finance_data1,
      company_symbol2 => finance_data2
    }
  end
  let(:result) { nil }

  before do
    allow(ENVied).to receive(:MAX_CONCURRENCY_COUNT).and_return(concurrency_count)
    allow(FinanceDataRepository).to receive(:get).with(company_symbol1).and_return(finance_data1)
    allow(FinanceDataRepository).to receive(:get).with(company_symbol2).and_return(finance_data2)
  end

  it 'calls finance data repository to retrieve finance data' do
    expect(FinanceDataRepository).to receive(:get).twice
    get
  end

  it 'returns retrieved finance data' do
    EM.synchrony do
      result = described_class.get(companies)
      expect(result).to eq(expected_result)

      EM.stop
    end
  end
end
