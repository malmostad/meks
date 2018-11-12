FactoryBot.define do
  factory :placement_extra_cost do
    date { Date.today }
    amount { rand 1000..2000 }
    comment { 'Foo bar' }
    placement { create(:placement) }
  end
end
