# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password_digest { BCrypt::Password.create('12345') }
    role { User::ROLES.keys.sample }
    status { :active }
    confirmed_at { Time.current }
  end
end
