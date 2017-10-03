module Report
  class EconomyPerRefugeeStatus < Workbooks
    def create!
      @axlsx    = Axlsx::Package.new
      @workbook = @axlsx.workbook
      @style    = Style.new(@axlsx)

      add_sheet
      # add_sub_sheets

      @axlsx.serialize File.join(Rails.root, 'reports', @filename)
    end

    def add_sheet(name = @sheet_name)
      @sheet = @workbook.add_worksheet(name: name)
      fill_sheet
    end

    def add_sub_sheets
      records.each_with_index do |status, i|
        sheet = Report::EconomyPerRefugeeStatusSubSheets.new(status: status, axlsx: @axlsx)
        sheet.create!
        @sheet.add_hyperlink(location: "'#{i18n_name(status[:name])}'!A1", ref: "A#{i + 2}", target: :sheet)
      end
    end

    def records
      RateCategory.includes(:rates).all
    end

    # Returns all placements within the range
    def placements_within_range
      @_placements_within_range ||= begin
        Placement.includes(
          :moved_out_reason, :legal_code,
          refugee: %i[countries languages ssns dossier_numbers
                      gender homes placements municipality
                      deregistered_reason payments],
          home: %i[languages type_of_housings
                   owner_type target_groups languages costs]
        ).within_range(@from, @to)
      end
    end

    # Returns a single refugee's all placements within the range
    def refugee_placements_within_range(refugee)
      placements_within_range.map do |pl|
        pl if pl.refugee.id == refugee.id
      end.compact
    end

    def refugees(category)
      rates(category).uniq.map { |hash| hash[:refugee] }
    end

    def rates(category)
      Statistics::Rates.refugees_rates_for_category(category, @range)
    end

    def costs(category)
      refugees(category).map do |refugee|
        placements = refugee_placements_within_range(refugee)
        Statistics::Cost.placements_costs_and_days(placements, @range)
      end.flatten
    end

    def payments(category)
      refugees(category).map do |refugee|
        Statistics::Payment.amount_and_days(refugee.payments, @range)
      end.flatten
    end

    def columns(category = RateCategory.first, i = 0)
      row = i + 2
      [
        {
          heading: 'Barnens status',
          query: category.human_name
        },
        {
          heading: 'Budgeterad kostnad',
          query: costs(category).map { |rate| rate[:amount] * rate[:days] }.sum
        },
        {
          heading: 'Förväntad schablon',
          query: rates(category).map { |rate| rate[:amount] * rate[:days] }.sum
        },
        {
          heading: 'Avvikelse',
          query: "=C#{row}-B#{row}"
        },
        {
          heading: 'Utbetald schablon',
          query: payments(category).map { |payment| payment[:amount] * payment[:days] }.sum
        },
        {
          heading: 'Avvikelse mellan förväntad och utbetald schablon',
          query: "=E#{row}-C#{row}"
        }
      ]
    end

    def last_row(row_number)
      [
        'SUMMA:',
        "=SUM(B2:B#{row_number})",
        "=SUM(C2:C#{row_number})",
        "=SUM(D2:D#{row_number})",
        "=SUM(E2:E#{row_number})",
        "=SUM(F2:F#{row_number})"
      ]
    end
  end
end
