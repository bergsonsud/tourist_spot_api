# frozen_string_literal: true

describe OpenCageService do
  describe "#call" do
    context "when API returns data" do
      let(:latitude) { 40.7128 }
      let(:longitude) { -74.0060 }
      let(:api_key) { "your_api_key" } # Set your API key here

      before do
        ENV["OPENCAGEDATA_API_KEY"] = api_key
        stub_request(:any, /api.opencagedata.com/).to_return(
          body: '{"total_results": 1, "results": [{"components": {"country": "United States", "attraction": "Statue of Liberty"}, "annotations": {"currency": {"name": "United States Dollar", "symbol": "$"}}}]}',
        )
      end

      it "returns tourist spot information" do
        service = described_class.new(latitude, longitude)
        result = service.call

        expect(result).to(eq({
          country: "United States",
          attraction: "Statue of Liberty",
          currency_name: "United States Dollar",
          currency_symbol: "$",
        }))
      end
    end

    context "when API returns no data" do
      let(:latitude) { 0 }
      let(:longitude) { 0 }
      let(:api_key) { "your_api_key" } # Set your API key here

      before do
        ENV["OPENCAGEDATA_API_KEY"] = api_key
        stub_request(:any, /api.opencagedata.com/).to_return(
          body: '{"total_results": 0}',
        )
      end

      it "does not build tourist spot information" do
        service = described_class.new(latitude, longitude)
        result = service.call

        expect(result).to(be_nil)
      end
    end
  end
end
