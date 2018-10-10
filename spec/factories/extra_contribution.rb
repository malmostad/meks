FactoryBot.define do
  factory :extra_contribution do
    period_start { Time.now }
    period_end { Time.now + 1.year }
    fee { rand 1000..2000 }
    expense { rand 1000..2000 }
    refugee { create(:refugee) }
    extra_contribution_type { create(:extra_contribution_type) }
  end
end
