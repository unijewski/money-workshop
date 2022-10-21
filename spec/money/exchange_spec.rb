# frozen_string_literal: true

RSpec.describe Exchange do
  subject { described_class.new }

  describe "#exchange" do
    let(:money) { Money.new(10, "USD") }

    context "when currencies are valid" do
      before do
        fixture_path = Pathname(__FILE__).dirname + "../fixtures/valid_conversion.json"
        response_body = File.read(fixture_path)

        allow(Money.configuration).to receive(:api_key).and_return("123456")
        stub_request(:get, "https://api.apilayer.com/currency_data/convert")
          .with(
            query: { from: "USD", to: "GBP", amount: "10.00" },
            headers: { apikey: "123456" }
          )
          .to_return(status: 200, body: response_body, headers: { content_type: "application/json" })
      end

      it { expect(subject.convert(money, "GBP")).to eq(BigDecimal("8.78395")) }
    end

    context "when currencies aren't valid" do
      before do
        fixture_path = Pathname(__FILE__).dirname + "../fixtures/invalid_conversion.json"
        response_body = File.read(fixture_path)

        allow(Money.configuration).to receive(:api_key).and_return("123456")
        stub_request(:get, "https://api.apilayer.com/currency_data/convert")
          .with(
            query: { from: "USD", to: "test", amount: "10.00" },
            headers: { apikey: "123456" }
          )
          .to_return(status: 200, body: response_body, headers: { content_type: "application/json" })
      end

      it { expect { subject.convert(money, "test") }.to raise_error Exchange::InvalidCurrencyConversion }
    end
  end
end
