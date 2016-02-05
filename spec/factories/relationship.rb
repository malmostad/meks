FactoryGirl.define do
  factory :relationship do
    refugee { create(:refugee) }
    related { create(:refugee) }
    type_of_relationship { create(:type_of_relationship) }
  end
end
