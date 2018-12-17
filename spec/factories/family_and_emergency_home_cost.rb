FactoryBot.define do
  factory :family_and_emergency_home_cost do
    period_start { Time.now }
    period_end { Time.now + 1.year }
    fee { rand 1000..2000 }
    expense { rand 1000..2000 }
    contractor_name { 'Firstname familyname' }
    contractor_birthday { '1980-01-15' }
    contactor_employee_number { 123_456 }
    placement { create(:placement) }
  end
end
