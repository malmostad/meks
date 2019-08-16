FactoryBot.define do
  factory :ssn do
    person { create(:person) }
    date_of_birth { Date.today - 4.years - rand(16).years }
    extension { rand(1000..9999) }
  end
end
