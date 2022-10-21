# frozen_string_literal: true

module Kernel
  def Money(amount, currency = Money.default_currency) # rubocop:disable Naming/MethodName
    Money.new(amount, currency)
  end
end
