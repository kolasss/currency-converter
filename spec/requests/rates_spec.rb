# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/rates' do
  describe 'GET /index' do
    context 'with roubles param' do
      let(:cbr) { instance_double(Banks::Cbr) }
      let(:rates) { { usd: BigDecimal('77.0863'), eur: BigDecimal('83.7639') } }

      before do
        allow(Banks::Cbr).to receive(:new).and_return(cbr)
        allow(cbr).to receive(:rates).and_return(rates)
      end

      it 'renders a successful response' do
        get rates_url, params: { roubles: 15.99 }
        expect(response).to be_successful
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with invalid param' do
      it 'renders a JSON response with errors' do
        get rates_url, params: { roubles: 'десять' }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end

    context 'with out param' do
      it 'renders a JSON response with errors' do
        get rates_url
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including('application/json'))
      end
    end
  end
end
