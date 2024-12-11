# frozen_string_literal: true

FactoryBot.define do
  factory :survey do
    title { Faker::Lorem.sentence(word_count: 3) }
    company
  end
end
