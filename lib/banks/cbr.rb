# frozen_string_literal: true

module Banks
  class Cbr
    def rates
      data = cached_rates
      {
        usd: find_rate(data, 'USD'),
        eur: find_rate(data, 'EUR')
      }
    end

    private

    def cached_rates
      Rails.cache.fetch('cbr_rates', expires_in: 1.day) do
        bank_rates
      end
    end

    def bank_rates
      date = DateTime.current.in_time_zone('Europe/Moscow').to_date
      response = client.call(:get_curs_on_date, message: { 'On_date' => date })
      response.body.dig(
        :get_curs_on_date_response, :get_curs_on_date_result, :diffgram, :valute_data, :valute_curs_on_date
      )
    end

    def client
      @client ||= Savon.client(wsdl: 'https://www.cbr.ru/DailyInfoWebServ/DailyInfo.asmx?WSDL')
    end

    def find_rate(data, code)
      BigDecimal(data.find { |currency| currency[:vch_code] == code }.fetch(:vcurs))
    end
  end
end
