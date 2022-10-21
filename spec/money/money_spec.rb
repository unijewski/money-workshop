# frozen_string_literal: true

RSpec.describe Money do
  subject { described_class.new(10, "USD") }

  describe "#to_s" do
    it { expect(subject.to_s).to eq("10.00 USD") }
  end

  describe "#inspect" do
    it { expect(subject.inspect).to eq("#<Money 10.00 (USD)>") }
  end

  %w[usd eur gbp chf pln].each do |currency|
    describe ".from_#{currency}", :aggregate_failures do
      money = described_class.public_send("from_#{currency}", 10)
      it { expect(money).to be_an_instance_of(Money) }
      it { expect(money.to_s).to eq("10.00 #{currency.upcase}") }
    end
  end

  describe "#Money" do
    it "creates a Money object" do
      money = Money(10, "PLN")
      expect(money).to be_an_instance_of(Money)
      expect(money.to_s).to eq("10.00 PLN")
    end
  end
end
