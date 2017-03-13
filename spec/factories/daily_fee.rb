FactoryGirl.define do
  factory :daily_fee do
    home { create(:home) }
    start_date { Date.today - rand(4).years }
    fee { rand(500..5000) }
  end
end
