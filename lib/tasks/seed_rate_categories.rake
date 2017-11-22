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
        human_name: 'Ankomstbarn 0–17 år',
        description: ''
      },

      {
        name: 'assigned_0_17',
        qualifier: 1,
        human_name: 'Anvisade barn 0–17 år',
        description: ''
      },

      {
        name: 'temporary_permit_0_17',
        qualifier: 2,
        human_name: 'TUT-barn 0–17 år',
        description: ''
      },
      {
        name: 'temporary_permit_18_20',
        qualifier: 3,
        human_name: 'TUT-barn 18–20 år',
        description: ''
      },
      {
        name: 'residence_permit_0_17',
        qualifier: 4,
        human_name: 'PUT-barn 0–17 år',
        description: ''
      },
      {
        name: 'residence_permit_18_20',
        qualifier: 5,
        human_name: 'PUT-barn 18–20 år',
        description: ''
      }
    ].each do |rc|
      rc.except! :rate
      r = RateCategory.create!(rc)
      # rate1 = { amount: rand(1000..2000), start_date: '2017-01-01', end_date: '2017-06-30' }
      # rate2 = { amount: rand(1000..2000), start_date: '2017-07-01', end_date: '2017-12-31' }
      # r.rates << Rate.new(rate1)
      # r.rates << Rate.new(rate2)
      rate = { amount: 0, start_date: '2017-01-01', end_date: '2017-12-31' }
      r.rates << Rate.new(rate)
      r.save!
    end
  end
end
