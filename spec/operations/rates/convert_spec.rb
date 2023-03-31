# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rates::Convert do
  subject(:call) { described_class.new.call(roubles) }

  let(:cbr) { instance_double(Banks::Cbr) }
  let(:rates) { { usd: BigDecimal('77.0863'), eur: BigDecimal('83.7639') } }

  before do
    allow(Banks::Cbr).to receive(:new).and_return(cbr)
    allow(cbr).to receive(:rates).and_return(rates)
  end

  context 'with valid param' do
    let(:roubles) { 1490.96 }

    it 'returns converted data' do
      expect(call.success?).to be true
      expect(call.value!).to eq({ usd: 19.35, eur: 17.8 })
    end

    context 'with another rates' do
      let(:rates) { { usd: BigDecimal('68.0863'), eur: BigDecimal('98.7639') } }

      it 'returns converted data' do
        expect(call.value!).to eq({ usd: 21.9, eur: 15.1 })
      end
    end
  end

  context 'with invalid param' do
    let(:roubles) { 'тысяча' }

    it 'returns failure' do
      expect(call.success?).to be false
      expect(call.failure).to eq(:invalid_param)
    end
  end
end
