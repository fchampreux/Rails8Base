FactoryBot.define do
  factory :group do
    sequence(:code) { |n| "group_#{n}" }
    sort_code { "a" }
    is_active { true }

    after(:build) do |group|
      creator = FactoryBot.create(:user)
      group.owner_id      ||= creator.id
      group.created_by_id ||= creator.id
      group.updated_by_id ||= creator.id
    end
  end
end
