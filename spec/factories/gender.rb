FactoryBot.define do
  factory :gender do
    sequence(:name) { |n| "gender-#{n}" }
  end
end
