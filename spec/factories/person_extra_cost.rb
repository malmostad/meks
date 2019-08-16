FactoryBot.define do
  factory :person_extra_cost do
    date { Time.now }
    amount { rand 1000..2000 }
    comment { 'Foo bar' }
    person { create(:person) }
  end
end
