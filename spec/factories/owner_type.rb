FactoryBot.define do
  factory :owner_type do
    sequence(:name) { |n| "owner_type-#{n}" }
  end
end
