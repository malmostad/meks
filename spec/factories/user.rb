FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "username-#{n}" }
    sequence(:name) { |n| "name-#{n}" }
    role { [:reader, :writer, :admin][rand(3)] }
  end
end
