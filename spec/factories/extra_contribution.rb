FactoryBot.define do
  factory :extra_contribution do
    period_start { Time.now }
    period_end { Time.now + 1.year }
    fee { rand 1000..2000 }
    expense { rand 1000..2000 }
    contractor_name { 'Firstname familyname' }
    contractor_birthday { '1980-01-15' }
    contactor_employee_number { 123_456 }

    monthly_cost { rand 1000..2000 }
    comment { 'Foo bar kommentar' }

    person { create(:person) }
    extra_contribution_type { create(:extra_contribution_type) }
  end
end
