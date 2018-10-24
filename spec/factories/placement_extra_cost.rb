FactoryBot.define do
  factory :placement_extra_cost do
    date { Date.today }
    amount { rand 1000..2000 }
    placement { create(:placement) }
  end
end
