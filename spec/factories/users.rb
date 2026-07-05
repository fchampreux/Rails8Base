FactoryBot.define do
  factory :user do
    sequence(:code) { |n| "user_#{n}" }
    first_name    { Faker::Name.first_name }
    last_name     { Faker::Name.last_name }
    email         { Faker::Internet.unique.email }
    password      { "Password123!" }
    active_from   { 1.year.ago.to_date }
    active_to     { 10.years.from_now.to_date }
    uuid          { SecureRandom.uuid }
    is_active     { false }
    confirmed_at  { Time.current }

    # Explicit here (rather than relying solely on User#self_reference_ownership)
    # because shoulda-matchers' uniqueness matchers persist the built record via
    # save(validate: false), which skips before_validation callbacks entirely.
    after(:build) do |user|
      next if user.owner_id.present? && user.created_by_id.present? && user.updated_by_id.present?

      reserved_id = ActiveRecord::Base.connection.select_value(
        "SELECT nextval(pg_get_serial_sequence('users', 'id'))"
      ).to_i
      user.id            ||= reserved_id
      user.owner_id      ||= reserved_id
      user.created_by_id ||= reserved_id
      user.updated_by_id ||= reserved_id
    end

    trait :unconfirmed do
      confirmed_at { nil }
    end
  end
end
