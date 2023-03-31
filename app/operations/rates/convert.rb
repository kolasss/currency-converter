# frozen_string_literal: true

module Rates
  class Convert
    include Dry::Monads[:result, :do]

    def call(roubles)
      roubles = yield to_big_decimal(roubles)
      rates = yield bank_rates

      result = {
        usd: multiply_round(roubles, rates[:usd]),
        eur: multiply_round(roubles, rates[:eur])
      }

      Success(result)
    end

    private

    def to_big_decimal(roubles)
      return Failure(:invalid_param) if roubles.blank?

      Success(BigDecimal(roubles.to_s))
    rescue ArgumentError
      Failure(:invalid_param)
    end

    def bank_rates
      Success(Banks::Cbr.new.rates)
    rescue ArgumentError
      Failure(:error_getting_rates)
    end

    def multiply_round(roubles, rate)
      (roubles / rate).ceil(2).to_f
    end
  end
end
