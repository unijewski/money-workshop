class Money
  attr_accessor :amount, :currency

  def initialize(amount, currency)
    @amount = amount
    @currency = currency
  end

  def to_s
    "#{precise_amount} #{currency}"
  end

  def inspect
    "#<Money #{precise_amount} (#{currency})>"
  end

  private

  def precise_amount
    format("%.2f", amount)
  end
end
