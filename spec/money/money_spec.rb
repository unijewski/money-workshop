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

  describe "#method_missing" do
    context "when a currency exists" do
      before do
        allow(CurrencyConverterApi)
          .to receive_message_chain(:get, :parsed_response)
          .and_return("success" => true, "result" => 8.78395)
      end

      it "does not raise an error", :aggregate_failures do
        expect(subject.respond_to?(:to_eur)).to eq(true)
        expect { subject.to_eur }.not_to raise_error
      end
    end

    context "when a currency does not exist" do
      it "raises an error", :aggregate_failures do
        expect { subject.asd_eur }.to raise_error(NoMethodError)
        expect(subject.respond_to?(:asd_eur)).to eq(false)
        expect { subject.to_asd }.to raise_error(NoMethodError)
        expect(subject.respond_to?(:to_asd)).to eq(false)
      end
    end
  end
end
