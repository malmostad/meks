FactoryBot.define do
  factory :type_of_housing do
    sequence(:name) { |n| "type_of_housing-#{n}" }
  end
end
