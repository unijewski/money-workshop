# frozen_string_literal: true

require_relative "currency_converter_api"

class Exchange
  InvalidCurrencyConversion = Class.new(StandardError)

  def convert(money, currency_out)
    amount = money.precise_amount
    currency_in = money.currency

    api_response = fetch_rate(amount, currency_in, currency_out)
    raise InvalidCurrencyConversion unless api_response["success"]

    BigDecimal(api_response["result"].to_s)
  end

  private

  def fetch_rate(amount, currency_in, currency_out)
    CurrencyConverterApi.get(
      "/convert", query: { from: currency_in, to: currency_out, amount: amount }
    ).parsed_response
  end
end
