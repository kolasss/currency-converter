# frozen_string_literal: true

module Rates
  class Convert
    include Dry::Monads[:result, :do]

    def call(rubles)
      rubles = yield to_big_decimal(rubles)
      rates = yield bank_rates

      result = {
        usd: calculate(rubles, rates[:usd]),
        eur: calculate(rubles, rates[:eur])
      }

      Success(result)
    end

    private

    def to_big_decimal(rubles)
      return Failure(:invalid_param) if rubles.blank?

      Success(BigDecimal(rubles.to_s))
    rescue ArgumentError
      Failure(:invalid_param)
    end

    def bank_rates
      Success(Banks::Cbr.new.rates)
    rescue ArgumentError
      Failure(:error_getting_rates)
    end

    def calculate(rubles, rate)
      (rubles / rate).ceil(2).to_f
    end
  end
end
