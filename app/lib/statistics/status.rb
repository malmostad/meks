module Statistics
  class Status < Base
    def self.statuses
      [
        { name: 'refugee.in_arrival', refugees: :in_arrival },
        { name: 'refugee.temporary_permit', refugees: :temporary_permit },
        { name: 'refugee.residence_permit', refugees: :residence_permit }
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
    def self.in_arrival
      type1 = Refugee
              .where.not(registered: nil)
              .where(deregistered: nil)
              .where(municipality: nil)
              .where(municipality_placement_migrationsverket_at: nil)
              .where(residence_permit_at: nil)
              .where(temporary_permit_starts_at: nil)
              .where(citizenship_at: nil)
              .where(sof_placement: false)

      type2 = Refugee
              .where.not(registered: nil)
              .where.not(municipality: nil)
              .where('municipality_placement_migrationsverket_at > ?', Date.today)
              .where(deregistered: nil)

      # Return an AcitiveRecord relation
      Refugee.where(id: type1 + type2)
    end

    def self.temporary_permit
      Refugee.where.not(temporary_permit_starts_at: nil)
    end

    def self.residence_permit
      Refugee.where.not(residence_permit_at: nil)
    end

    def initialize(refugee)
      @refugee = refugee
    end

    # Returns the asylum event for the refugee with latest date
    def asylum
      @_asylum ||= begin
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
        Hash[dates.map! { |k| [k.to_s, @refugee.send(k)] }]

        # Delete blanks
        dates = dates.delete_if { |_k, v| v.blank? }

        # Get the event with the latest date
        dates.sort_by { |_k, v| v }.last
      end
    end

    def format_asylum
      return 'Ingen status' if asylum.blank?
      I18n.t('simple_form.labels.refugee.' + asylum.first) + ' ' + asylum.second.to_s
    end
  end
end
