namespace :db do
  desc 'Seed data for rate categories'
  task seed_rate_categories: :environment do
    if Rate.count.positive? || RateCategory.count.positive?
      puts 'Run RateCategory.destroy_all first'
      exit
    end
    [
      {
        name: 'arrival_0_17',
        qualifier: 0,
        human_name: 'Ankomstbarn 0–17 år'
      },

      {
        name: 'assigned_0_17',
        qualifier: 1,
        human_name: 'Anvisade barn 0–17 år'
      },

      {
        name: 'temporary_permit_0_17',
        qualifier: 2,
        human_name: 'TUT-barn 0–17 år'
      },
      {
        name: 'temporary_permit_18_20',
        qualifier: 3,
        human_name: 'TUT-barn 18–20 år'
      },
      {
        name: 'residence_permit_0_17',
        qualifier: 4,
        human_name: 'PUT-barn 0–17 år'
      },
      {
        name: 'residence_permit_18_20',
        qualifier: 5,
        human_name: 'PUT-barn 18–20 år'
      }
    ].each do |rc|
      rc.except! :rate
      r = RateCategory.create!(rc)
      # rate = { amount: rand(1000..2000), start_date: Date.today.beginning_of_year, end_date: Date.today.end_of_year }
      # r.rates << Rate.new(rate)
      r.save!
    end
  end
end
