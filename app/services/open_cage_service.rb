# frozen_string_literal: true

class OpenCageService
  attr_accessor :latitude, :longitude, :api_key

  def initialize(latitude, longitude)
    self.latitude = latitude
    self.longitude = longitude
    self.api_key = ENV["OPENCAGEDATA_API_KEY"]
  end

  def call
    uri = URI("https://api.opencagedata.com/geocode/v1/json?q=#{latitude}+#{longitude}&key=#{api_key}")
    data = get_data(uri)
    build_tourist_spot(data) if data["total_results"] >= 1
  end

  def get_data(uri)
    FaradayRequestService.new(uri).call
  end

  private

  def build_tourist_spot(data)
    {
      country: data.dig("results", 0, "components", "country"),
      attraction: data.dig("results", 0, "components", "attraction"),
      currency_name: data.dig("results", 0, "annotations", "currency", "name"),
      currency_symbol: data.dig("results", 0, "annotations", "currency", "symbol"),
    }
  end
end
