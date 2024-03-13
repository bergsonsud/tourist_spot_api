# frozen_string_literal: true

class TouristSpotDetail < ApplicationRecord
  belongs_to :tourist_spot

  after_initialize :updated_values?

  def updated_values?
    return false if new_record?
    return false if updated_at >= 10.minutes.ago

    update_values
  end

  def update_values
    name = I18n.transliterate(tourist_spot.name).downcase
    data = get_new_data(name)

    if data.present? && data["cod"] == 200
      update!(
        {
          climate: data.dig("weather", 0, "description"),
          temperature: data.dig("main", "temp").round(2),
        },
      )
    end
  end

  # :nocov:
  def get_new_data(name)
    OpenWeatherMapService.new(name, "metric").call
  end
end
