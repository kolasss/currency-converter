# frozen_string_literal: true

class RatesController < ApplicationController
  def index
    result = Rates::Convert.new.call(params[:roubles])

    if result.success?
      render json: { result: result.value! }
    else
      render json: { error: result.failure }, status: :unprocessable_entity
    end
  end
end
