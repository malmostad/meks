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
        min_age: 0,
        max_age: 17,
        base_qualifier: 'arrival_0_17',
        human_name: 'Ankomstbarn 0–17 år',
        description: 'Måste:
– Ha födelsdatum

Från-datum beräknas på senaste datum av följande:
– minimiålder
– inskrivningsdatum

Till-datum beräknas på tidigaste datum av följande:
– maxålder + 1 år - 1 dag
– avslutsdatum
– anvisningsdatum
– TUT startar
– PUT startar
– medborgarskap',
        rate: { amount: 0, start_date: '2017-01-01', end_date: '2017-12-31' }
      },
      {
        name: 'assigned_0_17',
        min_age: 0,
        max_age: 17,
        base_qualifier: 'assigned_0_17',
        human_name: 'Anvisade barn 0–17 år',
        description: 'Måste:
– ha födelsdatum

Från-datum beräknas på senaste datum av följande:
– vara 0–17 år
– vara utskriven till Malmö
– vara anvisad

Till-datum beräknas på tidigaste datum av följande:
– vara avslutad',
        rate: { amount: 0, start_date: '2017-01-01', end_date: '2017-12-31' }
      },
      {
        name: 'temporary_permit_0_17',
        min_age: 0,
        max_age: 17,
        base_qualifier: 'temporary_permit',
        human_name: 'TUT-barn 0–17 år',
        description: 'Måste:
– ha födelsdatum
– ha datum för TUT startar
– ha datum för TUT slutar
– ha TUT som är längre än 12 månader

Från-datum beräknas på senaste datum av följande:
– minimiålder
– var utskriven till Malmö
– ha startdatum för TUT

Till-datum beräknas på tidigaste datum av följande:
– maxålder + 1 år - 1 dag
– avslutsdatum för TUT
– datum för PUT
– avslutsdatum',
        rate: { amount: 0, start_date: '2017-01-01', end_date: '2017-12-31' }
      },
      {
        name: 'temporary_permit_18_20',
        min_age: 18,
        max_age: 20,
        base_qualifier: 'temporary_permit',
        human_name: 'TUT-barn 18–20 år',
        description: 'Måste:
– ha födelsdatum
– ha datum för TUT startar
– ha datum för TUT slutar
– ha TUT som är längre än 12 månader

Från-datum beräknas på senaste datum av följande:
– minimiålder
– var utskriven till Malmö
– ha startdatum för TUT

Till-datum beräknas på tidigaste datum av följande:
– maxålder + 1 år - 1 dag
– avslutsdatum för TUT
– datum för PUT
– avslutsdatum',
        rate: { amount: 0, start_date: '2017-01-01', end_date: '2017-12-31' }
      },
      {
        name: 'residence_permit_0_17',
        min_age: 0,
        max_age: 17,
        base_qualifier: 'residence_permit',
        human_name: 'PUT-barn 0–17 år',
        description: 'Måste:
– ha födelsdatum

Från-datum beräknas på senaste datum av följande:
– minimiålder
– startdatum för PUT
– utskriven till Malmö

Till-datum beräknas på tidigaste datum av följande:
– maxålder + 1 år - 1 dag
– medborgarskap
– avslutsdatum',
        rate: { amount: 0, start_date: '2017-01-01', end_date: '2017-12-31' }
      },
      {
        name: 'residence_permit_18_20',
        min_age: 18,
        max_age: 20,
        base_qualifier: 'residence_permit',
        human_name: 'PUT-barn 18–20 år',
        description: 'Måste:
– ha födelsdatum

Från-datum beräknas på senaste datum av följande:
– minimiålder
– startdatum för PUT
– utskriven till Malmö

Till-datum beräknas på tidigaste datum av följande:
– maxålder + 1 år - 1 dag
– medborgarskap
– avslutsdatum',
        rate: { amount: 0, start_date: '2017-01-01', end_date: '2017-12-31' }
      }
    ].each do |rc|
      rate = rc[:rate]
      rc.except! :rate
      r = RateCategory.create!(rc)
      r.rates << Rate.new(rate) if rate.present?
      r.save!
    end
  end
end
