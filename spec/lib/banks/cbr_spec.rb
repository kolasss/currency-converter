# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Banks::Cbr do
  describe '#rates' do
    subject(:rates) do
      VCR.use_cassette('banks_cbr_rates') do
        described_class.new.rates
      end
    end

    it 'returs hash with exchange rates' do
      expect(rates).to eq({ usd: BigDecimal('77.0863'), eur: BigDecimal('83.7639') })
    end

    it 'get data from the bank' do
      rates
      expect(a_request(:post, 'http://www.cbr.ru/DailyInfoWebServ/DailyInfo.asmx')).to have_been_made
    end

    context 'with cache' do
      let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }

      before do
        allow(Rails).to receive(:cache).and_return(memory_store)
      end

      after do
        Rails.cache.clear
      end

      it 'caches data from the bank' do
        VCR.use_cassette('banks_cbr_rates', allow_playback_repeats: true) do
          described_class.new.rates
          described_class.new.rates
        end
        expect(a_request(:post, 'http://www.cbr.ru/DailyInfoWebServ/DailyInfo.asmx')).to have_been_made.once
      end
    end
  end
end
