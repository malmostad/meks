namespace :db do
  desc 'Seed data for rate categories'
  task seed_rate_categories: :environment do
    if Rate.count.positive? || RateCategory.count.positive?
      puts 'Run RateCategory.destroy_all first'
      exit
    end
    [
      {
        name: "arrival_0_17",
        human_name: "Ankomstbarn 0–17 år",
        qualifier: "arrival_0_17",
        min_age: 0,
        max_age: 17
      },
      {
        name: "assigned_0_17",
        human_name: "Anvisade barn 0–17 år",
        qualifier: "assigned_0_17",
        min_age: 0,
        max_age: 17
      },
      {
        name: "temporary_permit_0_17",
        human_name: "TUT-barn 0–17 år",
        qualifier: "temporary_permit",
        min_age: 0,
        max_age: 17
      },
      {
        name: "temporary_permit_18_20",
        human_name: "TUT-barn 18–20 år",
        qualifier: "temporary_permit",
        min_age: 18,
        max_age: 20
      },
      {
        name: "residence_permit_0_17",
        human_name: "PUT-barn 0–17 år",
        qualifier: "residence_permit",
        min_age: 0,
        max_age: 17
      },
      {
        name: "residence_permit_18_20",
        human_name: "PUT-barn 18–20 år",
        qualifier: "residence_permit",
        min_age: 18,
        max_age: 20
      }
    ].each do |rc|
      rc.except! :rate
      r = RateCategory.create!(rc)
      rate = { amount: rand(1000..2000), start_date: Date.today.beginning_of_year, end_date: Date.today.end_of_year }
      r.rates << Rate.new(rate)
      r.save!
    end
  end
end
