FactoryGirl.define do
  factory :legal_code do
    sequence(:name) { |n| "legal_code-#{n}" }
  end
end
