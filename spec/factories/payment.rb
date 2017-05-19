FactoryGirl.define do
  factory :payment do
    payment_import { create(:payment_import) }
    refugee { create(:refugee) }
    period_start { Date.today - rand(3..6).months }
    period_end { Date.today - rand(1..2).months }
    amount { rand(500..5000) }
  end
end
