FactoryBot.define do
  factory :po_rate do
    rate_under_65 { 30.32 }
    rate_between_65_and_81 { 30.64 }
    rate_from_82 { 30.64 }
    start_date { '2019-01-01' }
    end_date { '2019-12-31' }
  end
end
