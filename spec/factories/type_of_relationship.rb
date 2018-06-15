FactoryBot.define do
  factory :type_of_relationship do
    sequence(:name) { |n| "type_of_relationship-#{n}" }
  end
end
