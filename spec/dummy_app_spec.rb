# frozen_string_literal: true

require 'dummy_app'

RSpec.describe DummyApp do
  subject(:run_app) { described_class.run }

  before do
    allow(LOGGER).to receive(:info)
  end

  it 'logs the run' do
    expect(LOGGER).to receive(:info).with('Run dummy test').once
    run_app
  end
end
