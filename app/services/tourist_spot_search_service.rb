# frozen_string_literal: true

class TouristSpotSearchService
  attr_accessor :query, :language, :units

  def initialize(query, units = "metrics", language = "en")
    self.query = I18n.transliterate(query)
    self.units = units
    self.language = language
  end

  def call
    tourist_spot = TouristSpot.find_or_initialize_by(name: query)

    if tourist_spot.new_record?
      data = OpenWeatherMapService.new(query, units).call
      return [nil, { error: "Invalid search parameters" }] if data.blank? || data["cod"] == 404
    end

    if data.present? && data["cod"] == 200
      create_tourist_spot(tourist_spot, data)
    end

    [tourist_spot, tourist_spot.find_create_details(language)]
  end

  def details_attributes(data, open_cage_data, language = "en")
    {
      language: language,
      country: open_cage_data[:country],
      climate: data.dig("weather", 0, "description"),
      temperature: data.dig("main", "temp").round(2),
      currency: open_cage_data[:currency_name],
      currency_symbol: open_cage_data[:currency_symbol],
    }
  end

  def create_tourist_spot(tourist_spot, data)
    open_cage_data = OpenCageService.new(data.dig("coord", "lat"), data.dig("coord", "lon")).call

    tourist_spot.name = data["name"]
    tourist_spot.latitude = data.dig("coord", "lat")
    tourist_spot.longitude = data.dig("coord", "lon")
    tourist_spot.tourist_spot_details.build(details_attributes(data, open_cage_data))
    tourist_spot.save!
  end
end
