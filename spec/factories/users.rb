FactoryBot.define do
  factory :user do
    sequence(:code) { |n| "user_#{n}" }
    first_name  { Faker::Name.first_name }
    last_name   { Faker::Name.last_name }
    email       { Faker::Internet.unique.email }
    password    { "Password123!" }
    active_from { 1.year.ago.to_date }
    active_to   { 10.years.from_now.to_date }
    uuid        { SecureRandom.uuid }
    is_active   { true }
  end
end
