# frozen_string_literal: true

FactoryBot.define do
  factory :survey do
    title { Faker::Lorem.sentence(word_count: 3) }
    company

    trait :with_questions do
      transient do
        questions_count { 3 }
      end

      after(:create) do |survey, evaluator|
        create_list(:question, evaluator.questions_count, survey: survey)
      end
    end
  end
end
