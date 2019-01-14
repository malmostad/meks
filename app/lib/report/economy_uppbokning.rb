module Report
  class EconomyUppbokning < Workbooks
    def initialize(options = {})
      super(options)
    end

    def records
      tut_0_17  = RateCategory.where(name: 'temporary_permit_0_17').first
      put_0_17  = RateCategory.where(name: 'residence_permit_0_17').first
      tut_18_20 = RateCategory.where(name: 'temporary_permit_18_20').first
      put_18_20 = RateCategory.where(name: 'residence_permit_18_20').first

      per_legal_code = {
        sol: refugees_with_legal_code(1),
        lvu_and_sol_lvu: refugees_with_legal_code(2, 3),
        all: refugees_with_legal_code
      }

      {
        sol_tut_put_0_17: per_rate_category(per_legal_code[:sol], tut_0_17, put_0_17),
        sol_tut_put_18_20: per_rate_category(per_legal_code[:sol], tut_18_20, put_18_20)
      }
    end

    def per_rate_category(refugees, *categories)
      refugees.map do |refugee|
        rates_for_refugee = ::Economy::RatesForRefugee.new(refugee, from: @from, to: @to)

        days_and_amounts = categories.map do |category|
          rates_for_refugee.send(category.qualifier[:meth], category)
        end.flatten.compact

        next if days_and_amounts.empty?

        { refugee: refugee, data: days_and_amounts }
      end.reject(&:blank?)
    end

    def refugees_with_legal_code(*ids)
      refugees =
        Refugee
        .includes(
          :ssns, :dossier_numbers,
          :municipality,
          :refugee_extra_costs, :extra_contributions,
          placements: [:legal_code, :placement_extra_costs, :family_and_emergency_home_costs,
                       home: [:costs]]
        )
        .where(municipalities: { our_municipality: true })
        .where('placements.moved_in_at <= ?', @to)
        .where('placements.moved_out_at is ? or placements.moved_out_at >= ?', nil, @from)

      return refugees.where(placements: { legal_code: ids }) unless ids.blank?

      refugees
    end

    def columns(refugee = Refugee.new, i = 0)
      row = i + 2

      [
        {
          heading: 'Dossiernummer',
          query: refugee.dossier_number
        },
        {
          heading: 'Personnummer',
          query: refugee.ssn
        },
        {
          heading: 'Extra personnummer',
          query: refugee.ssns.map(&:full_ssn).join(', ')
        },
        {
          heading: 'Kommun',
          query: refugee.municipality&.name
        },
        {
          heading: 'Förväntad intäkt',
          query: self.class.sum_formula(
            ::Economy::RatesForRefugee.new(refugee, @interval).as_formula,
            # Special case, see class doc
            ::Economy::ReplaceRatesWithActualCosts.new(refugee, @interval).as_formula
          ),
          style: 'currency'
        },
        {
          heading: 'Antal dygn',
          query: 'todo'
        }
      ]
    end

    def last_row(row)
      [
        'SUMMA:',
        '',
        '',
        '',
        "=SUM(E2:E#{row})"
      ]
    end
  end
end
