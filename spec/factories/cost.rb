FactoryGirl.define do
  factory :cost do
    home { create(:home) }
    start_date { Date.today - rand(7..12).months }
    end_date { Date.today - rand(1..6).months }
    amount { rand(500..5000) }
  end
end
