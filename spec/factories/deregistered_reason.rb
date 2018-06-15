FactoryBot.define do
  factory :deregistered_reason do
    sequence(:name) { |n| "deregistered_reason-#{n}" }
  end
end
