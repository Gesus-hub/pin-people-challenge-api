# frozen_string_literal: true

FactoryBot.define do
  factory :survey do
    title { Faker::Lorem.sentence(word_count: 3) }
    company

    transient do
      questions_count { 3 }
      options_count { 4 }
    end

    after(:create) do |survey, evaluator|
      create_list(:question, evaluator.questions_count, survey: survey).each do |question|
        create_list(:option, evaluator.options_count, question: question)
      end
    end
  end
end
