FactoryBot.define do
  factory :family_and_emergency_home_cost do
    period_start { Time.now }
    period_end { Time.now + 1.year }
    fee { rand 1000..2000 }
    expense { rand 1000..2000 }
    placement { create(:placement) }
  end
end
