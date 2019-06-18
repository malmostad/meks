FactoryBot.define do
  factory :one_time_payment do
    amount { 123 }
    start_date { '2019-01-01' }
    end_date { '2019-12-31' }
  end
end
