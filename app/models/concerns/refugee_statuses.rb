module RefugeeStatuses
  extend ActiveSupport::Concern

  module ClassMethods
    def statuses
      [
        { name: 'refugee.in_arrival', refugees: :in_arrival },
        { name: 'refugee.temporary_permit', refugees: :temporary_permit },
        { name: 'refugee.residence_permit', refugees: :residence_permit },
        { name: 'refugee.designated', refugees: :designated }
      ]
    end

    # Comment in Swedish are from project specifications
    # Ankomstbarn typ 1:
    # - ska ha inskrivningsdatum
    # - ska inte ha anvisningskommun
    # - ska inte ha anvisningsdatum
    # - ska inte ha status avslutat
    # - ska inte datum för PUT
    # - ska inte datum för TUT
    # - ska inte datum för medborgarskap
    # - ska inte ha SoF-placering
    #
    # Ankomstbarn typ 2:
    # - ska ha inskrivningsdatum
    # - ska ha anvisningskommun
    # - ska ha anvisningsdatum där anvisningsdatumet ligger i framtiden
    # - ska inte ha status avslutat
    def in_arrival
      type1 = Refugee
              .includes(placements: { home: :costs })
              .where.not(registered: nil)
              .where(deregistered: nil)
              .where(municipality: nil)
              .where(municipality_placement_migrationsverket_at: nil)
              .where(residence_permit_at: nil)
              .where(temporary_permit_starts_at: nil)
              .where(citizenship_at: nil)
              .where(sof_placement: false)

      type2 = Refugee
              .includes(placements: { home: :costs })
              .where.not(registered: nil)
              .where.not(municipality: nil)
              .where('municipality_placement_migrationsverket_at > ?', Date.today)
              .where(deregistered: nil)

      # Return an AcitiveRecord relation
      where(id: type1 + type2)
    end

    # TODO: Change to spec def
    def temporary_permit
      where.not(temporary_permit_starts_at: nil)
    end

    # TODO: Change to spec def
    def residence_permit
      where.not(residence_permit_at: nil)
    end

    def designated
      # TODO: implement
      # Lagrum SoL. Schablonen ska beräknas för barn som ej har fyllt 18 år
      # samt från och med anvisningsdatum till Malmö och
      # avslutas samma dag som står i kolumnen "Utskriven till Malmö".
      # Om datum för "Utskriven till Malmö" är inte ifylld, då
      # är det datum i raden "Avslutad" som avgör när schablonen upphör.
      find(1, 2)
    end
  end

  included do
    # Get the asylum event with latest date
    def asylum_status
      dates = %i[
        registered
        municipality_placement_migrationsverket_at
        municipality_placement_per_agreement_at
        residence_permit_at
        checked_out_to_our_city
        temporary_permit_starts_at
        temporary_permit_ends_at
        deregistered
      ]

      # Create a key/value hash from the array
      Hash[dates.map! { |k| [k.to_s, send(k)] }]

      # Delete blanks
      dates = dates.delete_if { |_k, v| v.blank? }

      # Get the event with the latest date
      dates.sort_by { |_k, v| v }.last
    end
  end
end
