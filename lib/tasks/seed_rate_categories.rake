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
        human_name: 'Ankomstbarn 0–17 år',
        description: "– SKA INTE ha datum avslutad som har inträffat\n" \
        "– SKA INTE ha datum för Avslutad som har inträffat\n" \
        "– SKA vara under 18 år\n" \
        "– SKA ha inskrivningsdatum idag eller tidigare\n" \
        "– SKA INTE ha Anvisningsdatum som har inträffat\n" \
        "– SKA INTE ha TUT som inträffat\n" \
        "– SKA INTE ha PUT som inträffat\n" \
        "– SKA INTE ha medborgarskap",
        rate: { amount: 0, start_date: '2017-01-01', end_date: '2017-12-31' }
      },
      {
        name: 'assigned_0_17',
        human_name: 'Anvisade barn 0–17 år',
        description: "– SKA INTE ha datum avslutad som har inträffat\n" \
        "– SKA INTE ha datum för Avslutad som har inträffat\n" \
        "– SKA vara under 18 år\n" \
        "– SKA ha Anvisningsdatum till Malmö idag eller tidigare\n" \
        "– Utskriven till Malmö SKA INTE ha inträffat senare än igår",
        rate: { amount: 0, start_date: '2017-01-01', end_date: '2017-12-31' }
      },
      {
        name: 'tut_0_17',
        human_name: 'TUT-barn 0–17 år',
        description: "– SKA INTE ha datum avslutad som har inträffat\n" \
        "– SKA vara under 18 år\n" \
        "– SKA ha datum för TUT startar och SKA ligga idag eller tidigare\n" \
        "– SKA ha datum för TUT slutar och SKA INTE ha inträffat\n" \
        "– SKA ha datum för Utskriven till Malmö i går eller tidigare\n" \
        "– TUT SKA vara längre än 12 månader\n" \
        "– SKA INTE ha datum för PUT som har inträffat",
        rate: { amount: 0, start_date: '2017-01-01', end_date: '2017-12-31' }
      },
      {
        name: 'tut_18_20',
        human_name: 'TUT-barn 18–20 år',
        description: "– SKA INTE ha datum Avslutad som har inträffat\n" \
        "– SKA vara mellan 18–20 år\n" \
        "– SKA ha datum för TUT startar och SKA ligga idag eller tidigare\n" \
        "– SKA ha datum för TUT slutar och SKA INTE ha inträffat\n" \
        "– SKA ha datum för Utskriven till Malmö i går eller tidigare\n" \
        "– TUT SKA vara längre än 12 månader\n" \
        "– SKA INTE ha datum för PUT som har inträffat",
        rate: { amount: 0, start_date: '2017-01-01', end_date: '2017-12-31' }
      },
      {
        name: 'put_0_17',
        human_name: 'PUT-barn 0–17 år',
        description: "– SKA INTE ha datum avslutad som har inträffat\n" \
        "– SKA vara under 18 år\n" \
        "– SKA INTE ha datum Avslutad som har inträffat\n" \
        "– SKA ha startdatum för PUT som har inträffat\n" \
        "– SKA vara Utskriven till Malmö i går eller tidigare\n" \
        "– SKA INTE ha datum för medborgarskap",
        rate: { amount: 0, start_date: '2017-01-01', end_date: '2017-12-31' }
      },
      {
        name: 'put_18_20',
        human_name: 'PUT-barn 18–20 år',
        description: "– SKA INTE ha datum avslutad som har inträffat\n" \
        "– SKA vara mellan 18–20 år\n" \
        "– SKA vara Utskriven till Malmö i går eller tidigare\n" \
        "– SKA INTE ha datum för medborgarskap",
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
