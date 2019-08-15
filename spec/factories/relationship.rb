FactoryBot.define do
  factory :relationship do
    person { create(:person) }
    related { create(:person) }
    type_of_relationship { create(:type_of_relationship) }
  end
end
