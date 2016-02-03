FactoryGirl.define do
  factory :placement do
    association :refugee, :home
  end
end
