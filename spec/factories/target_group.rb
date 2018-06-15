FactoryBot.define do
  factory :target_group do
    sequence(:name) { |n| "target_group-#{n}" }
  end
end
