FactoryGirl.define do
  factory :municipality do
    sequence(:name) { |n| "municipality-#{n}" }
  end
end
