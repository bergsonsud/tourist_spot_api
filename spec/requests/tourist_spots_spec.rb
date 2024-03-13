# frozen_string_literal: true

require "rails_helper"

RSpec.describe("TouristSpots", type: :request) do
  describe "GET #search" do
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
    let(:units) { "metric" }
    let(:language) { "en" }
    let(:api_key) { "api_key" }

    context "when search parameters are provided" do
      before do
        allow(OpenWeatherMapService).to(receive(:new).and_return(double(call: weather_data)))
        allow(OpenCageService).to(receive(:new).and_return(double(call: open_cage_data)))
      end

      it "calls TouristSpotSearchService with provided parameters" do
        get "/api/v1/tourist_spots/search",
          params: { query: query, units: units, language: language },
          headers: { "Accept" => "application/json" }

        json_response = JSON.parse(response.body)
        expect(json_response["name"]).to(eq("New York"))
        expect(json_response["country"]).to(eq("United States"))
        expect(json_response["climate"]).to(eq("Clouds"))
        expect(json_response["temperature"]).to(eq("20.5"))
        expect(json_response["currency"]).to(eq("United States Dollar"))
        expect(json_response["symbol"]).to(eq("$"))
      end
    end

    context "when search parameters are missing" do
      it "returns a bad request response" do
        get "/api/v1/tourist_spots/search", headers: { "Accept" => "application/json" }

        expect(response).to(have_http_status(:bad_request))
      end
    end

    context "when tourist spot is not found" do
      before do
        allow(OpenWeatherMapService).to(receive(:new).and_return(double(call: nil)))
        allow(OpenCageService).to(receive(:new).and_return(double(call: nil)))
      end

      it "renders a bad request response" do
        get "/api/v1/tourist_spots/search",
          params: { query: "a", units: "metric", language: "en" },
          headers: { "Accept" => "application/json" }

        expect(response).to(have_http_status(:bad_request))
        expect(response.body).to(include("error"))
      end
    end
  end
end
