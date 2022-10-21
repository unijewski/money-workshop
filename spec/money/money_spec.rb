# frozen_string_literal: true

RSpec.describe Money do
  subject { described_class.new(10, "USD") }

  describe "#to_s" do
    it { expect(subject.to_s).to eq("10.00 USD") }
  end

  describe "#inspect" do
    it { expect(subject.inspect).to eq("#<Money 10.00 (USD)>") }
  end

  describe "#precise_amount" do
    it { expect(subject.precise_amount).to eq("10.00") }
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

  describe "#exchange_to" do
    context "when given currency is valid" do
      before do
        allow(CurrencyConverterApi)
          .to receive_message_chain(:get, :parsed_response)
          .and_return("success" => true, "result" => 8.78395)
      end

      it "creates a new instance" do
        expect(subject.exchange_to("GBP").inspect).to eq("#<Money 8.78 (GBP)>")
      end
    end

    context "when given currency is invalid" do
      it "raises an error" do
        expect { subject.exchange_to("test").to raise_error(ArgumentError, "Currency not supported") }
      end
    end
  end
end
