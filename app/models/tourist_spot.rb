# frozen_string_literal: true

class TouristSpot < ApplicationRecord
  has_many :tourist_spot_details, dependent: :destroy
  accepts_nested_attributes_for :tourist_spot_details, allow_destroy: true

  validates :name, presence: true, uniqueness: true
  validates :name, :latitude, :longitude, presence: true

  def tourist_spot_details_by_language(language = "en")
    tourist_spot_details.find_by(language: language)
  end

  def find_create_details(language = "en")
    details = tourist_spot_details_by_language(language)
    if details.blank?
      english_details = tourist_spot_details_by_language

      translated_response = translate_fields(english_details, language)
      if translated_response.present?
        translated_fields = JSON.parse(translated_response, symbolize_names: true)
        details = TouristSpotDetail.create!(tourist_spot: self, language: language, **translated_fields)
      end
    end
    details
  end

  def translate_fields(details, language)
    return if details.blank?

    fields_to_translate = {
      climate: details.climate,
      currency: details.currency,
      currency_symbol: details.currency_symbol,
      temperature: details.temperature,
      country: details.country,
    }

    text_to_translate = fields_to_translate.values.join(", ")

    translated_text = TranslatorService.new(text_to_translate, language).call
    translated_values = fields_to_translate.keys.zip(translated_text.split(", ")).to_h
    translated_values.to_json
  end
end
