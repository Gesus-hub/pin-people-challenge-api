# frozen_string_literal: true

FactoryBot.define do
  factory :option do
    value { Faker::Lorem.word }
    question
  end
end
