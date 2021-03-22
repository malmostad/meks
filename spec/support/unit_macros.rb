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
        name: "arrival_0_17",
        human_name: "Ankomstbarn 0–17 år",
        qualifier: "arrival_0_17",
        min_age: 0,
        max_age: 17,
        rate: { amount: RATES[:arrival_0_17], start_date: '2018-01-01', end_date: '2018-12-31' }
      },

      {
        name: "assigned_0_17",
        human_name: "Anvisade barn 0–17 år",
        qualifier: "assigned_0_17",
        min_age: 0,
        max_age: 17,
        rate: { amount: RATES[:assigned_0_17], start_date: '2018-01-01', end_date: '2018-12-31' }
      },

      {
        name: "temporary_permit_0_17",
        human_name: "TUT-barn 0–17 år",
        qualifier: "temporary_permit",
        min_age: 0,
        max_age: 17,
        rate: { amount: RATES[:temporary_permit_0_17], start_date: '2018-01-01', end_date: '2018-12-31' }
      },
      {
        name: "temporary_permit_18_20",
        human_name: "TUT-barn 18–20 år",
        qualifier: "temporary_permit",
        min_age: 18,
        max_age: 20,
        rate: { amount: RATES[:temporary_permit_18_20], start_date: '2018-01-01', end_date: '2018-12-31' }
      },
      {
        name: "residence_permit_0_17",
        human_name: "PUT-barn 0–17 år",
        qualifier: "residence_permit",
        min_age: 0,
        max_age: 17,
        rate: { amount: RATES[:residence_permit_0_17], start_date: '2018-01-01', end_date: '2018-12-31' }
      },
      {
        name: "residence_permit_18_20",
        human_name: "PUT-barn 18–20 år",
        qualifier: "residence_permit",
        min_age: 18,
        max_age: 20,
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
