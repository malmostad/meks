module ReportGenerator
  class Template
    def initialize(axlsx)
      @axlsx = axlsx
    end

    def style
      @style ||= Style.new(@axlsx)
    end

    def placements(records)
      @axlsx.workbook.add_worksheet do |sheet|
        sheet.add_row [
          'Barn',
          'Dossiernummer',
          'Personnummer',
          'Boende',
          'Placerad',
          'Utskriven',
          'Total placeringstid (dagar)',
          'Anledning till utskrivning',
          'Kommentar till utskrivning'
        ],
        style: style.heading

        records.find_each(batch_size: 1000) do |placement|
          sheet.add_row([
            placement.refugee.name,
            placement.refugee.dossier_numbers.map(&:name).join(', '),
            placement.refugee.ssns.map(&:name).join(', '),
            placement.home.name,
            placement.moved_in_at,
            placement.moved_out_at,
            placement.placement_time,
            placement.moved_out_reason.present? ? placement.moved_out_reason.name : '',
            placement.comment
          ],
          # Styling all cells individually like this is very expensive
          style: [
            style.normal,
            style.normal,
            style.normal,
            style.normal,
            style.date,
            style.date,
            style.normal,
            style.normal,
            style.wrap
          ],
          types: [
            :string,
            :string,
            :string,
            :string,
            :date,
            :date,
            :integer,
            :string,
            :string
          ])
        end
        sheet.column_info.each { |c| c.width = 20 }
        sheet.column_info[4].width = 12
        sheet.column_info[5].width = 12
        sheet.column_info[8].width = 40
      end
    end

    def refugees(records)
      @axlsx.workbook.add_worksheet do |sheet|
        sheet.add_row [
          'Namn',
          'Registrerad',
          'Avregistrerad',
          'Dossiernummer',
          'Personnummer',
          'Anvisad',
          'Kön',
          'Land',
          'Språk',
          'Aktuellt boenden',
          'All boenden',
          'Placeringstid (dagar)'
        ], style: style.heading

        records.find_each do |refugee|
          sheet.add_row([
            refugee.name,
            refugee.registered,
            refugee.deregistered,
            refugee.dossier_numbers.map(&:name).join(', '),
            refugee.ssns.map(&:name).join(', '),
            refugee.municipality.present? ? refugee.municipality.name : '',
            refugee.gender.present? ? refugee.gender.name : '',
            refugee.languages.map(&:name).join(', '),
            refugee.countries.map(&:name).join(', '),
            refugee.placements.where(moved_out_at: nil).map(&:home).map(&:name).join(', '),
            refugee.homes.map(&:name).join(', '),
            refugee.total_placement_time
          ],
          style: [
            style.normal,
            style.date,
            style.date,
            style.normal,
            style.normal,
            style.normal,
            style.normal,
            style.normal,
            style.normal,
            style.normal,
            style.wrap,
            style.normal
          ],
          types: [
            :string,
            :date,
            :date,
            :string,
            :string,
            :string,
            :string,
            :string,
            :string,
            :string,
            :string,
            :integer
          ])
          sheet.column_info.each { |c| c.width = 20 }
          sheet.column_info[6].width = 8
          sheet.column_info[10].width = 25
        end
      end
    end
  end
end
