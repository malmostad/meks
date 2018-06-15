FactoryBot.define do
  factory :rate do
    rate_category { create(:rate_category) }
    amount { rand(500..5000) }
    start_date { Date.today - rand(7..12).months }
    end_date { Date.today - rand(1..6).months }
  end
end
