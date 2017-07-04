FactoryGirl.define do
  factory :rate_category do
    sequence(:name) { |n| "rate_category-#{n}" }
    sequence(:description) { |n| "desc-#{n}" }
    from_age { 0 }
    to_age { 17 }
    legal_code { create(:legal_code) }
  end
end
