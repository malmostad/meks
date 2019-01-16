module Report
  class EconomyUppbokning < Workbooks
    def initialize(options = {})
      super(options)

      # Rate categories (Schablonkategorier)
      @assigned_0_17   = RateCategory.where(name: 'assigned_0_17').first
      @tut_0_17        = RateCategory.where(name: 'temporary_permit_0_17').first
      @put_0_17        = RateCategory.where(name: 'residence_permit_0_17').first
      @tut_18_20       = RateCategory.where(name: 'temporary_permit_18_20').first
      @put_18_20       = RateCategory.where(name: 'residence_permit_18_20').first
      @arrival_0_17    = RateCategory.where(name: 'arrival_0_17').first

      # Refugees with placements with specific legal codes by ID(s) (Lagrum)
      @sol             = refugees_with_legal_code(1)
      @lvu_and_sol_lvu = refugees_with_legal_code(2, 3)
      @all             = refugees_with_legal_code # All refugees
    end

    def records
      sub_sheets.map do |sub_sheet|
        {
          name: sub_sheet[:name],
          refugees: sub_sheet[:refugees]
        }
      end
    end

    def columns(record = { name: nil, refugees: [] }, i = 0)
      [
        {
          heading: 'Barnens status',
          query: record[:name]
        },
        {
          heading: 'Förväntad intäkt',
          query: self.class.sum_formula(record[:refugees].sum { |r| r[:data].sum { |d| d[:amount] * d[:days] } }),
          style: 'currency'
        }
      ]
    end

    # Refugees with combination of given rate categories and legal codes (as above)
    def sub_sheets
      [
        {
          name: 'SoL, Anvisade barn, 0–17',
          refugees: per_rate_category(@sol, @assigned_0_17)
        },
        {
          name: 'SoL, PUT+TUT, 0–17',
          refugees: per_rate_category(@sol, @tut_0_17, @put_0_17)
        },
        {
          name: 'SoL, PUT+TUT, 18–20',
          refugees: per_rate_category(@sol, @tut_18_20, @put_18_20)
        },
        {
          name: 'LVU+SoL med LVU, Anvisade 0–17',
          refugees: per_rate_category(@lvu_and_sol_lvu, @assigned_0_17)
        },
        {
          name: 'LVU+SoL med LVU, PUT 0–17',
          refugees: per_rate_category(@lvu_and_sol_lvu, @tut_0_17, @put_0_17)
        },
        {
          name: 'LVU+SoL med LVU, PUT 18–20',
          refugees: per_rate_category(@lvu_and_sol_lvu, @tut_18_20, @put_18_20)
        },
        {
          name: 'Alla lagrum, Ankomstbarn, 0–17',
          refugees: per_rate_category(@all, @arrival_0_17)
        }
      ]
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

    # Returns refugees with placements that matches the given id(s) for legal code(s)
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

    def sub_sheet_columns(refugee = Refugee.new, i = 0)
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
  end
end
