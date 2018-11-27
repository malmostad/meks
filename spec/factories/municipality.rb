FactoryBot.define do
  factory :municipality do
    sequence(:name) { |n| "municipality-#{n}" }
    our_municipality { false }
  end
end
