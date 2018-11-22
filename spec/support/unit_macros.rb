module UnitMacros
  RATES = {
    arrival_0_17: 1412,
    assigned_0_17: 1712,
    temporary_permit_0_17: 1987,
    temporary_permit_18_20: 1678,
    residence_permit_0_17: 1843,
    residence_permit_18_20: 1976
  }.freeze

  REPORT_INTERVAL = { from: '2018-04-01', to: '2018-06-30' }.freeze

  def detect_rate_by_amount(rates, amount)
    rates.detect { |rate| rate[:amount] == amount }
  end

  def create_rate_categories_with_rates
    RateCategory.destroy_all
    [
      {
        name: 'arrival_0_17',
        qualifier: 0,
        human_name: 'Ankomstbarn 0–17 år',
        rate: { amount: RATES[:arrival_0_17], start_date: '2018-01-01', end_date: '2018-12-31' }
      },

      {
        name: 'assigned_0_17',
        qualifier: 1,
        human_name: 'Anvisade barn 0–17 år',
        rate: { amount: RATES[:assigned_0_17], start_date: '2018-01-01', end_date: '2018-12-31' }
      },

      {
        name: 'temporary_permit_0_17',
        qualifier: 2,
        human_name: 'TUT-barn 0–17 år',
        rate: { amount: RATES[:temporary_permit_0_17], start_date: '2018-01-01', end_date: '2018-12-31' }
      },
      {
        name: 'temporary_permit_18_20',
        qualifier: 3,
        human_name: 'TUT-barn 18–20 år',
        rate: { amount: RATES[:temporary_permit_18_20], start_date: '2018-01-01', end_date: '2018-12-31' }
      },
      {
        name: 'residence_permit_0_17',
        qualifier: 4,
        human_name: 'PUT-barn 0–17 år',
        rate: { amount: RATES[:residence_permit_0_17], start_date: '2018-01-01', end_date: '2018-12-31' }
      },
      {
        name: 'residence_permit_18_20',
        qualifier: 5,
        human_name: 'PUT-barn 18–20 år',
        rate: { amount: RATES[:residence_permit_18_20], start_date: '2018-01-01', end_date: '2018-12-31' }
      }
    ].each do |rc|
      rate = rc[:rate]
      rc.except! :rate
      r = RateCategory.create!(rc)
      r.rates << Rate.new(rate)
      r.save!
    end
  end

  def read_report(filename)
    File.read(File.join(Rails.root, 'reports', filename))
  end
end
