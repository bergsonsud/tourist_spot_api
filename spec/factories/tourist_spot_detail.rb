# frozen_string_literal: true

FactoryBot.define do
  factory :tourist_spot_detail do
    tourist_spot
    language { "en" }
    country { Faker::Address.country }
    climate { Faker::Lorem.word }
    temperature { Faker::Number.decimal(l_digits: 2) }
    currency { Faker::Currency.name }
    currency_symbol { Faker::Currency.symbol }
  end
end
