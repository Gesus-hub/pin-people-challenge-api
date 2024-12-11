# frozen_string_literal: true

FactoryBot.define do
  factory :company do
    name { Faker::Company.unique.name }
    trade_name { Faker::Company.unique.name }
    email { Faker::Internet.email }
    website_facebook { Faker::Internet.url }
    business_description { Faker::Lorem.sentence(word_count: 3) }
    status { :active }
  end
end
