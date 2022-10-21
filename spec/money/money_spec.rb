# frozen_string_literal: true

RSpec.describe Money do
  subject { described_class.new(10, "USD") }

  describe "#to_s" do
    it { expect(subject.to_s).to eq("10.00 USD") }
  end

  describe "#inspect" do
    it { expect(subject.inspect).to eq("#<Money 10.00 (USD)>") }
  end
end
