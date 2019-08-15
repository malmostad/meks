FactoryBot.define do
  factory :payment do
    payment_import { create(:payment_import) }
    person { create(:person) }
    period_start { Date.today - rand(3..6).months }
    period_end { Date.today - rand(1..2).months }
    amount_as_string { "#{rand(500..5000)},00" }
  end
end
