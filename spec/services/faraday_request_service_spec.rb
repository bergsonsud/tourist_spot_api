# frozen_string_literal: true

RSpec.describe(FaradayRequestService, type: :service) do
  describe "#initialize" do
    context "when uri is nil" do
      it "raises an ArgumentError" do
        expect { described_class.new(nil) }.to(raise_error(ArgumentError, "URL cannot be nil or empty"))
      end
    end
  end

  describe "#call" do
    let(:uri) { "https://api.example.com" }
    let(:connection) { instance_double(Faraday::Connection) }
    let(:response) { instance_double(Faraday::Response, success?: true, body: "{}") }

    before do
      allow(Faraday).to(receive(:new).and_return(connection))
      allow(connection).to(receive(:get).and_return(response))
    end

    it "returns the parsed response body" do
      expect(described_class.new(uri).call).to(eq({}))
    end
  end
end
