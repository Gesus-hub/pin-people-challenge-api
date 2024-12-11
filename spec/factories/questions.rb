# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    content { Faker::Lorem.sentence(word_count: 5) }
    question_type { Question.question_types.keys.sample }
    survey
  end
end
