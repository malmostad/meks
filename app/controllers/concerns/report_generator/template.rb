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
        # 'Visa i MEKS' => {
        #   query: 'refugee_url(record)'
        # },
        'Primärt dossiernummer' => {
          query: 'record.primary_dossier_number'
        },
        'refugee.dossier_numbers' => {
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
        'refugee.comment' => {
          query: 'record.comment'
        },
        'refugee.registered' => {
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
          query: 'record.current_placements.map(&:home).map(&:name).join(", ")'
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
          query: 'record.placements.where(moved_out_at: nil).count',
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
        'home.movable_seats' => {
          query: 'record.movable_seats',
          type: :integer
        },
        'Summa platser' => {
          query: 'record.seats',
          type: :integer
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
        'Alla boende barnet bott på' => {
          query: 'record.refugee.homes.map(&:name).join(", ")'
        },
        'Primärt dossiernummer' => {
          query: 'record.refugee.primary_dossier_number'
        },
        'refugee.dossier_numbers' => {
          query: 'record.refugee.dossier_numbers.map(&:name).join(", ")'
        },
        'Ålder' => {
          query: 'record.refugee.age',
          type: :integer
        },
        'Primärt personnummer' => {
          query: 'record.refugee.primary_ssn.full_ssn'
        },
        'refugee.ssn' => {
          query: 'record.refugee.ssns.map(&:date_of_birth).join(", ")'
        },
        # 'Visa boende i MEKS' => {
        #   query: 'home_url(record.home)'
        # },
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
        }
      }
    end
  end
end
