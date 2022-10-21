require "bigdecimal"

class Money
  attr_accessor :amount, :currency

  CURRENCIES = %w[usd eur gbp chf pln].freeze

  def initialize(amount, currency)
    @amount = BigDecimal(amount.to_s)
    @currency = currency.upcase
  end

  def to_s
    "#{precise_amount} #{currency}"
  end

  def inspect
    "#<Money #{precise_amount} (#{currency})>"
  end

  CURRENCIES.each do |currency|
    define_singleton_method("from_#{currency}") do |argument|
      new(argument, currency)
    end
  end

  private

  def precise_amount
    format("%.2f", amount)
  end
end
