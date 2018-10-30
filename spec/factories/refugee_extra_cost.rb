FactoryBot.define do
  factory :refugee_extra_cost do
    date { Time.now }
    amount { rand 1000..2000 }
    comment 'Foo bar'
    refugee { create(:refugee) }
  end
end
