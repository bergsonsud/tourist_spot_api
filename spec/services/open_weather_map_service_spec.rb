# frozen_string_literal: true

describe OpenWeatherMapService do
  describe "#call" do
    context "with valid query and units" do
      let(:query) { "London" }
      let(:units) { "metric" }
      let(:api_key) { "your_api_key" } # Set your API key here

      before do
        ENV["OPENWEATHERMAP_API_KEY"] = api_key
        stub_request(:any, /api.openweathermap.org/).to_return(
          body: '{"cod": 200, "main": {"temp": 20.5}, "weather": [{"main": "Clouds"}]}',
        )
      end

      it "returns weather data" do
        service = described_class.new(query, units)
        result = service.call

        expect(result["cod"]).to(eq(200))
        expect(result["main"]["temp"]).to(eq(20.5))
        expect(result["weather"].first["main"]).to(eq("Clouds"))
      end
    end

    context "with invalid query or units" do
      let(:query) { "InvalidCity" }
      let(:units) { "invalid_units" }
      let(:api_key) { "your_api_key" } # Set your API key here

      before do
        ENV["OPENWEATHERMAP_API_KEY"] = api_key
        stub_request(:any, /api.openweathermap.org/).to_return(
          body: '{"cod": 404, "message": "city not found"}',
        )
      end

      it "returns nil" do
        service = described_class.new(query, units)
        result = service.call

        expect(result).to(be_nil)
      end
    end
  end
end
