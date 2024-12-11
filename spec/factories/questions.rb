# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    content { Faker::Lorem.sentence(word_count: 5) }
    question_type { Question.question_types.keys.sample }
    survey

    transient do
      options_count { 4 }
    end

    after(:create) do |question, evaluator|
      create_list(:option, evaluator.options_count, question: question)
    end
  end
end
