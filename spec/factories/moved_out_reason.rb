FactoryBot.define do
  factory :moved_out_reason do
    sequence(:name) { |n| "moved_out_reason-#{n}" }
  end
end
