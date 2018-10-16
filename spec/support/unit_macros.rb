module UnitMacros
  def create_rate_categories_with_rates(rates)
    RateCategory.destroy_all
    [
      {
        name: 'arrival_0_17',
        qualifier: 0,
        human_name: 'Ankomstbarn 0–17 år',
        rate: { amount: rates[:arrival_0_17], start_date: '2018-01-01', end_date: '2018-12-31' }
      },

      {
        name: 'assigned_0_17',
        qualifier: 1,
        human_name: 'Anvisade barn 0–17 år',
        rate: { amount: rates[:assigned_0_17], start_date: '2018-01-01', end_date: '2018-12-31' }
      },

      {
        name: 'temporary_permit_0_17',
        qualifier: 2,
        human_name: 'TUT-barn 0–17 år',
        rate: { amount: rates[:temporary_permit_0_17], start_date: '2018-01-01', end_date: '2018-12-31' }
      },
      {
        name: 'temporary_permit_18_20',
        qualifier: 3,
        human_name: 'TUT-barn 18–20 år',
        rate: { amount: rates[:temporary_permit_18_20], start_date: '2018-01-01', end_date: '2018-12-31' }
      },
      {
        name: 'residence_permit_0_17',
        qualifier: 4,
        human_name: 'PUT-barn 0–17 år',
        rate: { amount: rates[:residence_permit_0_17], start_date: '2018-01-01', end_date: '2018-12-31' }
      },
      {
        name: 'residence_permit_18_20',
        qualifier: 5,
        human_name: 'PUT-barn 18–20 år',
        rate: { amount: rates[:residence_permit_18_20], start_date: '2018-01-01', end_date: '2018-12-31' }
      }
    ].each do |rc|
      rate = rc[:rate]
      rc.except! :rate
      r = RateCategory.create!(rc)
      r.rates << Rate.new(rate)
      r.save!
    end
  end
end
