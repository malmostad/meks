FactoryGirl.define do
  factory :relationship do
    association :refugee, :related, :type_of_relationship
  end
end
