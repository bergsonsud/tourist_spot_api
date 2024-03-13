# frozen_string_literal: true

describe TouristSpotSearchService do
  describe "#call" do
    context "when tourist spot already exists" do
      let(:query) { "London" }
      let!(:existing_spot) { create(:tourist_spot, name: query) } # Assuming you have FactoryBot configured
      let!(:details) { create(:tourist_spot_detail, tourist_spot: existing_spot) }

      before do
        allow(TouristSpot).to(receive(:find_or_initialize_by).with(name: query).and_return(existing_spot))
      end

      it "returns existing tourist spot details" do
        service = described_class.new(query)
        result = service.call

        expect(result).to(eq([existing_spot, existing_spot.find_create_details("en")]))
      end
    end

    context "when tourist spot does not exist" do
      let(:query) { "New York" }
      let(:weather_data) do
        {
          "cod" => 200,
          "name" => "New York",
          "coord" => { "lat" => 40.7128, "lon" => -74.0060 },
          "main" => { "temp" => 20.5 },
          "weather" => [{ "description" => "Clouds" }],
        }
      end
      let(:open_cage_data) { { country: "United States", currency_name: "United States Dollar", currency_symbol: "$" } }

      before do
        allow(OpenWeatherMapService).to(receive(:new).and_return(double(call: weather_data)))
        allow(OpenCageService).to(receive(:new).and_return(double(call: open_cage_data)))
        allow_any_instance_of(described_class).to(receive(:create_tourist_spot).and_call_original)
      end

      it "creates and returns new tourist spot details" do
        service = described_class.new(query)
        result = service.call
        expect(result.first).to(be_a(TouristSpot))
      end
    end
  end
end
