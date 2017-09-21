FactoryGirl.define do
  factory :rate_category do
    sequence(:name) { |n| "rate_category-#{n}" }
    sequence(:human_name) { |n| "rate_category-human-name#{n}" }
    sequence(:description) { |n| "desc-#{n}" }
  end
end
