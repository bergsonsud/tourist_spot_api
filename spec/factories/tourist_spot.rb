# frozen_string_literal: true

FactoryBot.define do
  factory :tourist_spot do
    sequence(:name) { |n| "Tourist Spot #{n}" }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
  end
end
