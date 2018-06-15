FactoryBot.define do
  factory :setting do
    sequence(:key) { |n| "key-#{n}" }
    sequence(:human_name) { |n| "human_name-#{n}" }
    sequence(:value) { |n| "value-#{n}" }
  end
end
