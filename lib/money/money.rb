# frozen_string_literal: true

require_relative "configuration"
require_relative "exchange"
require "bigdecimal"

class Money
  include Comparable

  attr_accessor :amount, :currency

  class << self
    attr_accessor :default_currency
    attr_writer :configuration
  end

  CURRENCIES = %w[usd eur gbp chf pln].freeze

  def initialize(amount, currency = Money.default_currency)
    raise ArgumentError if currency.nil?

    @amount = BigDecimal(amount.to_s)
    @currency = currency.upcase
  end

  def to_s
    "#{precise_amount} #{currency}"
  end

  def inspect
    "#<Money #{precise_amount} (#{currency})>"
  end

  def precise_amount
    format("%.2f", amount)
  end

  CURRENCIES.each do |currency|
    define_singleton_method("from_#{currency}") do |argument|
      new(argument, currency)
    end
  end

  def exchange_to(currency)
    raise ArgumentError, "Currency not supported" unless allowed_currency?(currency)

    self.amount = Money.exchange.convert(self, currency)
    self.currency = currency.upcase
    self
  end

  def self.exchange
    Exchange.new
  end

  def method_missing(method_name)
    raise NoMethodError unless method_name.to_s.start_with?("to_")

    currency = method_name.to_s.split("_").last
    return super unless allowed_currency?(currency)

    exchange_to(currency)
  end

  def respond_to_missing?(method_name, include_private = false)
    currency = method_name.to_s.split("_").last
    (method_name.start_with?("to_") && allowed_currency?(currency)) || super
  end

  def <=>(other)
    exchange_to(other.currency).amount <=> other.amount
  end

  def self.using_default_currency(currency)
    self.default_currency = currency
    yield
  ensure
    self.default_currency = nil
  end

  %i[+ -].each do |method|
    define_method(method) do |arg|
      self.amount = amount.public_send(method, arg.exchange_to(currency).amount)
      self
    end
  end

  %i[* /].each do |method|
    define_method(method) do |arg|
      self.amount = amount.public_send(method, arg)
      self
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  private

  def allowed_currency?(currency)
    CURRENCIES.include?(currency.downcase)
  end
end
