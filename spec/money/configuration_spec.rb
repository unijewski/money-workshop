# frozen_string_literal: true

RSpec.describe Configuration do
  subject { described_class.new }

  describe "#api_key" do
    it { expect(subject.api_key).to eq("api_key_not_set") }
  end

  describe "#api_key=" do
    before do
      subject.api_key = "whatever"
    end

    it { expect(subject.api_key).to eq("whatever") }
  end
end
