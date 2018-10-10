FactoryBot.define do
  factory :extra_contribution_type do
    sequence(:name) { |n| "extra_contribution_type-#{n}" }
  end
end
