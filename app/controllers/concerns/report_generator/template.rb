module ReportGenerator
  class Template
    def refugees
      {
        'Namn' => {
          query: 'record.name'
        },
        'Visa i MEKS' => {
          query: 'refugee_url(record)'
        },
        'Primärt dossiernummer' => {
          query: 'record.primary_dossier_number'
        },
        'Alla dossiernummer' => {
          query: 'record.dossier_numbers.map(&:name).join(", ")'
        },
        'Ålder' => {
          query: 'record.age',
          type: :integer
        },
        'Primärt personnummer' => {
          query: 'record.primary_ssn.full_ssn'
        },
        'Alla personnummer' => {
          query: 'record.ssns.map(&:full_ssn).join(", ")'
        },
        'Kön' => {
          query: 'record.gender.name'
        },
        'Språk' => {
          query: 'record.languages.map(&:name).join(", ")'
        },
        'Land' => {
          query: 'record.countries.map(&:name).join(", ")'
        },
        'Insatsbild' => {
          query: 'record.special_needs? ? "Ja" : "Nej"'
        },
        'Kommentar' => {
          query: 'record.comment'
        },
        'Inskriven' => {
          query: 'record.registered',
          type: :date
        },
        'PUT' => {
          query: 'record.residence_permit_at',
          type: :date
        },
        'TUT startar' => {
          query: 'record.temporary_permit_starts_at',
          type: :date
        },
        'TUT slutar' => {
          query: 'record.temporary_permit_ends_at',
          type: :date
        },
        'Anvisad' => {
          query: 'record.municipality.name'
        },
        'Anvisad enligt Migrationsverket' => {
          query: 'record.municipality_placement_migrationsverket_at',
          type: :date
        },
        'Anvisad enligt överenskommelse' => {
          query: 'record.municipality_placement_per_agreement_at',
          type: :date
        },
        'Anvisad, kommentar' => {
          query: 'record.municipality_placement_comment'
        },
        'Avregisterad' => {
          query: 'record.deregistered',
          type: :date
        },
        'Avslutsorsak' => {
          query: 'record.deregistered_reason'
        },
        'Aktuellt boende' => {
          query: 'record.current_placements.map(&:home).map(&:name).join(", ")'
        },
        'Alla boende' => {
          query: 'record.homes.map(&:name).join(", ")'
        },
        'Total placeringstid (dagar)' => {
          query: 'record.total_placement_time',
          type: :integer
        },
        'Anhöriga' => {
          query: 'record.relateds.map(&:name).join(", ")'
        },
        'Angiven som anhöriga till' => {
          query: 'record.inverse_relateds.map(&:name).join(", ")'
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
