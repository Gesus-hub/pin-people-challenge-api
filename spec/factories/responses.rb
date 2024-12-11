# frozen_string_literal: true

FactoryBot.define do
  factory :response do
    value { Faker::Lorem.sentence(word_count: 2) }
    survey
    question
    user
  end
end
