# frozen_string_literal: true

class OpenWeatherMapService
  attr_accessor :api_key, :query, :units

  def initialize(query, units)
    self.api_key = ENV["OPENWEATHERMAP_API_KEY"]
    self.query = query
    self.units = units
  end

  def call
    uri = URI("https://api.openweathermap.org/data/2.5/weather?q=#{query}&appid=#{api_key}&units=#{units}")
    data = FaradayRequestService.new(uri).call

    if data["cod"] == 200
      data
    end
  end
end
