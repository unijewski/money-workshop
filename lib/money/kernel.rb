module Kernel
  def Money(amount, currency = Money.default_currency)
    Money.new(amount, currency)
  end
end
