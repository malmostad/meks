module ReportGenerator
  class Template
    def refugees
      {
        'Barn' => {
          query: 'name'
        },
        'Primärt dossiernummer' => {
          query: 'primary_dossier_number'
        },
        'Alla dossiernummer' => {
          query: 'dossier_numbers.map(&:name).join(", ")'
        },
        'Ålder' => {
          query: 'age',
          type: :integer
        },
        'Primärt personnummer' => {
          query: 'primary_ssn.full_ssn'
        },
        'Alla personnummer' => {
          query: 'ssns.map(&:full_ssn).join(", ")'
        },
        'Kön' => {
          query: 'gender.name'
        },
        'Språk' => {
          query: 'languages.map(&:name).join(", ")'
        },
        'Land' => {
          query: 'countries.map(&:name).join(", ")'
        },
        'Insatsbild' => {
          query: 'special_needs'
        },
        'Kommentar' => {
          query: 'comment'
        },
        'Inskriven' => {
          query: 'registered',
          type: :date
        },
        'PUT' => {
          query: 'residence_permit_at',
          type: :date
        },
        'TUT startar' => {
          query: 'temporary_permit_starts_at',
          type: :date
        },
        'TUT slutar' => {
          query: 'temporary_permit_ends_at',
          type: :date
        },
        'Anvisad' => {
          query: 'municipality.name'
        },
        'Anvisad enligt Migrationsverket' => {
          query: 'municipality_placement_migrationsverket_at',
          type: :date
        },
        'Anvisad enligt överenskommelse' => {
          query: 'municipality_placement_per_agreement_at',
          type: :date
        },
        'Anvisad, kommentar' => {
          query: 'municipality_placement_comment'
        },
        'Avregisterad' => {
          query: 'deregistered',
          type: :date
        },
        'Avslutsorsak' => {
          query: 'deregistered_reason'
        },
        'Aktuellt boende' => {
          query: 'placements.where(moved_out_at: nil).map(&:home).map(&:name).join(", ")'
        },
        'Alla boende' => {
          query: 'homes.map(&:name).join(", ")'
        },
        'Total placeringstid (dagar)' => {
          query: 'total_placement_time',
          type: :integer
        },
        'Anhöriga' => {
          query: 'relateds.map(&:name).join(", ")'
        },
        'Angiven som anhöriga till' => {
          query: 'inverse_relateds.map(&:name).join(", ")'
        }
      }
    end

    def homes(records)
      @axlsx.workbook.add_worksheet do |sheet|
        sheet.add_row [
          'Namn',
          'Telefon',
          'Fax',
          'Adress',
          'Postnummer',
          'Postort',
          'Boendeform',
          'Ägarform',
          'Målgrupp',
          'Kommentar',
          'Platser',
          'Garantiplatser',
          'Rörliga platser',
          'Språk',
          'Aktuella placeringar',
          'Placeringar totalt',
          'Total placeringstid',
          'Registrerad',
          'Senast uppdaterad'
        ], style: @style.heading

        records.find_each(batch_size: 1000) do |home|
          sheet.add_row([
            home.name,
            home.phone,
            home.fax,
            home.address,
            home.post_code,
            home.postal_town,
            home.type_of_housings.map(&:name).join(', '),
            home.owner_type,
            home.target_groups.map(&:name).join(', '),
            home.languages.map(&:name).join(', '),
            home.comment,
            home.seats,
            home.guaranteed_seats,
            home.movable_seats,
            home.current_placements_size,
            home.placements.size,
            home.total_placement_time,
            home.created_at,
            home.updated_at
          ],
          style: [
            @style.normal,
            @style.normal,
            @style.normal,
            @style.normal,
            @style.normal,
            @style.normal,
            @style.normal,
            @style.normal,
            @style.normal,
            @style.normal,
            @style.wrap,
            @style.normal,
            @style.normal,
            @style.normal,
            @style.normal,
            @style.normal,
            @style.normal,
            @style.date,
            @style.date
          ],
          types: [
            :string,
            :string,
            :string,
            :string,
            :string,
            :string,
            :string,
            :string,
            :string,
            :string,
            :string,
            :integer,
            :integer,
            :integer,
            :integer,
            :integer,
            :integer,
            :time,
            :time
          ])
          sheet.column_info.each { |c| c.width = 20 }
          sheet.column_info[9].width = 40
          sheet.column_info[12..18].each { |c| c.width = 15 }
        end
      end
    end
  end
end
