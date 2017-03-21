FactoryGirl.define do
  factory :rate_category do
    sequence(:name) { |n| "rate_caetgory-#{n}" }
    sequence(:description) { |n| "desc-#{n}" }
    from_age { 0 }
    to_age { 17 }
  end
end
