module ReportGenerator
  # Column centric definitions for AXSLX's row centric API
  # I18n keys is looked up in the simple_form list with the literal as default
  # queries will be evaled for the record set
  # `type` defaults to `:string`
  class Template
    def refugees
      {
        'refugee.name' => {
          query: 'record.name'
        },
        'Personnummer' => {
          query: 'record.ssn'
        },
        'Extra personnummer' => {
          query: 'record.ssns.map(&:full_ssn).join(", ")'
        },
        'Dossiernummer' => {
          query: 'record.dossier_number'
        },
        'Extra dossiernummer' => {
          query: 'record.dossier_numbers.map(&:name).join(", ")'
        },
        'Ålder' => {
          query: 'record.age',
          type: :integer
        },
        'refugee.gender' => {
          query: 'record.gender.name'
        },
        'refugee.languages' => {
          query: 'record.languages.map(&:name).join(", ")'
        },
        'refugee.countries' => {
          query: 'record.countries.map(&:name).join(", ")'
        },
        'refugee.special_needs' => {
          query: 'record.special_needs? ? "Ja" : "Nej"'
        },
        'refugee.social_worker' => {
          query: 'record.social_worker'
        },

        'refugee.registered' => {
          query: 'format_asylum_status(record.asylum_status)'
        },
        'PUT' => {
          query: 'record.residence_permit_at',
          type: :date
        },
        'refugee.checked_out_to_our_city' => {
          query: 'record.checked_out_to_our_city',
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
        'refugee.municipality' => {
          query: 'record.municipality.name'
        },
        'refugee.municipality_placement_migrationsverket_at' => {
          query: 'record.municipality_placement_migrationsverket_at',
          type: :date
        },
        'refugee.municipality_placement_per_agreement_at' => {
          query: 'record.municipality_placement_per_agreement_at',
          type: :date
        },
        'refugee.municipality_placement_comment' => {
          query: 'record.municipality_placement_comment'
        },
        'refugee.deregistered' => {
          query: 'record.deregistered',
          type: :date
        },
        'refugee.deregistered_reason' => {
          query: 'record.deregistered_reason'
        },

        'Aktuellt boende' => {
          query: 'record.placements.reject { |p| !p.moved_out_at.nil? }.map(&:home).map(&:name).join(", ")'
        },
        'Alla boende' => {
          query: 'record.homes.map(&:name).join(", ")'
        },
        'Total placeringstid (dagar)' => {
          query: 'record.total_placement_time',
          type: :integer
        },
        'refugee.relateds' => {
          query: 'record.relateds.map(&:name).join(", ")'
        },
        'Angiven som anhöriga till' => {
          query: 'record.inverse_relateds.map(&:name).join(", ")'
        },
        'Övriga anhöriga' => {
          query: 'record.refugee.other_relateds'
        }
      }
    end

    def homes
      {
        'home.name' => {
          query: 'record.name'
        },
        'home.phone' => {
          query: 'record.phone'
        },
        'home.fax' => {
          query: 'record.fax'
        },
        'home.address' => {
          query: 'record.address'
        },
        'home.post_code' => {
          query: 'record.post_code'
        },
        'home.postal_town' => {
          query: 'record.postal_town'
        },
        'home.type_of_housings' => {
          query: 'record.type_of_housings.map(&:name).join(", ")'
        },
        'home.owner_type' => {
          query: 'record.owner_type.name'
        },
        'home.target_groups' => {
          query: 'record.target_groups.map(&:name).join(", ")'
        },
        'home.languages' => {
          query: 'record.languages.map(&:name).join(", ")'
        },
        'home.comment' => {
          query: 'record.comment'
        },
        'Aktuella placeringar' => {
          query: 'record.placements.reject { |p| !p.moved_out_at.nil? }.size',
          type: :integer
        },
        'Placeringar totalt' => {
          query: 'record.placements.count',
          type: :integer
        },
        'Total placeringstid (dagar)' => {
          query: 'record.total_placement_time',
          type: :integer
        },
        'home.guaranteed_seats' => {
          query: 'record.guaranteed_seats',
          type: :integer
        },
        'Lediga platser' => {
          query: '(record.guaranteed_seats + record.movable_seats) - record.placements.reject { |p| !p.moved_out_at.nil? }.size',
          type: :integer
        },
        'home.movable_seats' => {
          query: 'record.movable_seats',
          type: :integer
        },
        'Summa platser' => {
          query: 'record.seats',
          type: :integer
        },
        'home.active' => {
          query: 'record.active? ? "Ja" : "Nej"'
        }
      }
    end

    def placements
      {
        # 'Visa placering i MEKS' => {
        #   query: 'edit_refugee_placement_url(record.refugee, record)'
        # },
        'Barn' => {
          query: 'record.refugee.name'
        },
        # 'Visa barn i MEKS' => {
        #   query: 'refugee_url(record.refugee)'
        # },
        'Boende' => {
          query: 'record.home.name'
        },
        'placement.moved_in_at' => {
          query: 'record.moved_in_at',
          type: :date
        },
        'placement.moved_out_at' => {
          query: 'record.moved_out_at',
          type: :date
        },
        'Total placeringstid (dagar)' => {
          query: 'record.placement_time',
          type: :integer
        },
        'placement.moved_out_reason' => {
          query: 'record.moved_out_reason.name'
        },
        'Kommentar till utskrivning' => {
          query: 'record.comment'
        },
        'Boende barnet bott på' => {
          query: 'record.refugee.homes.map(&:name).join(", ")'
        },
        'Barn, registrerad' => {
          query: 'record.refugee.registered',
          type: :date
        },
        'Barn, PUT' => {
          query: 'record.refugee.residence_permit_at',
          type: :date
        },
        'refugee.checked_out_to_our_city' => {
          query: 'record.refugee.checked_out_to_our_city',
          type: :date
        },
        'Barn, TUT startar' => {
          query: 'record.refugee.temporary_permit_starts_at',
          type: :date
        },
        'Barn, TUT slutar' => {
          query: 'record.refugee.temporary_permit_ends_at',
          type: :date
        },
        'Barn, anvisningskommun' => {
          query: 'record.refugee.municipality.name'
        },
        'Barn, anvisad enligt Migrationsverket' => {
          query: 'record.refugee.municipality_placement_migrationsverket_at',
          type: :date
        },
        'Barn, anvisad per överenskommelse' => {
          query: 'record.refugee.municipality_placement_per_agreement_at',
          type: :date
        },
        'Barn, kommunplacering' => {
          query: 'record.refugee.municipality_placement_comment'
        },
        'Barn, avregistrerad' => {
          query: 'record.refugee.deregistered',
          type: :date
        },
        'Barn, avslutsorsak' => {
          query: 'record.refugee.deregistered_reason'
        },
        'Barnets primära dossiernummer' => {
          query: 'record.refugee.dossier_number'
        },
        'Barnets dossiernummer' => {
          query: 'record.refugee.dossier_numbers.map(&:name).join(", ")'
        },
        'Barnets ålder' => {
          query: 'record.refugee.age',
          type: :integer
        },
        'Barnets primära personnummer' => {
          query: 'record.refugee.ssn'
        },
        'Barnets alla personnummer' => {
          query: 'record.refugee.ssns.map(&:full_ssn).join(", ")'
        },
        'Barnets kön' => {
          query: 'record.refugee.gender.name'
        },
        'Barnets språk' => {
          query: 'record.refugee.languages.map(&:name).join(", ")'
        },
        'Barnets härkomst' => {
          query: 'record.refugee.countries.map(&:name).join(", ")'
        },
        'Barn, speciella behov' => {
          query: 'record.refugee.special_needs? ? "Ja" : "Nej"'
        },
        'Barn, kommentar' => {
          query: 'record.refugee.comment'
        },
        'Barn anhöriga' => {
          query: 'record.refugee.relateds.map(&:name).join(", ")'
        },
        'Barn angiven som anhöriga till' => {
          query: 'record.refugee.inverse_relateds.map(&:name).join(", ")'
        },
        'Övriga anhöriga' => {
          query: 'record.refugee.other_relateds'
        },
        'Boendeform ' => {
          query: 'record.home.type_of_housings.map(&:name).join(", ")'
        },
        'Boende, ägartyp' => {
          query: 'record.home.owner_type.name'
        },
        'Boende, målgrupp' => {
          query: 'record.home.target_groups.map(&:name).join(", ")'
        },
        'Boende, språk' => {
          query: 'record.home.languages.map(&:name).join(", ")'
        },
        'Boendet är aktivt' => {
          query: 'record.home.active? ? "Ja" : "Nej"'
        },
        'Boende, kommentar' => {
          query: 'record.home.comment'
        },
        # 'Visa boende i MEKS' => {
        #   query: 'home_url(record.home)'
        # },
      }
    end
  end
end
