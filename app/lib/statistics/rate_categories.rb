module Statistics
  # TODO: limit queries by report range
  # Qualifiers for refugee rate categories (schabloner)
  class RateCategories < Refugee
    class << self
      CATEGORIES = %i[
        arrival_0_17
        assigned_0_17
        tut_0_17
        tut_18_20
        put_0_17
        put_18_20
      ].freeze

      # Returns an array of hashes with categories and their rates
      def amount_and_range
        RateCategory.all.map do |category|
          {
            id: category.id,
            name: category.name,
            human_name: category.human_name,
            rates: category.rates.map do |rate|
              { rate: rate.amount, from: rate.start_date, to: rate.end_date }
            end
          }
        end
      end

      def cats
        CATEGORIES.map do |category|
          send(category)
        end
      end

      def expected
        0
      end

      def arrival_0_17
        age_0_17.arrival
      end

      def assigned_0_17
        age_0_17.assigned
      end

      def tut_0_17
        age_0_17.tut
      end

      def tut_18_20
        age_18_20.tut
      end

      def put_0_17
        age_0_17.put
      end

      def put_18_20
        age_18_20.put
      end

      # Conditions for all categories
      # * SKA INTE ha datum för ”Avslutad” som har inträffat
      def default
        where('deregistered > ?  OR deregistered IS ?', Date.today, nil)
      end

      def age_0_17
        default.where('date_of_birth > ?', 18.years.ago)
      end

      def age_18_20
        default.where('date_of_birth <= ? and date_of_birth > ?', 18.years.ago, 21.years.ago)
      end

      # Ankomstbarn
      # * SKA ha inskrivningsdatum idag eller tidigare
      # * SKA INTE ha ”Anvisningsdatum” som har inträffat
      # * SKA INTE ha TUT som inträffat
      # * SKA INTE ha PUT som inträffat
      # * SKA INTE ha medborgarskap
      # FIXME: allow nils for dates?
      def arrival
        default
          .where('registered <= ?', Date.today)
          .where(
            'municipality_placement_migrationsverket_at > ? OR
             municipality_placement_migrationsverket_at IS ?',
            Date.today, nil
          )
          .where(
            'temporary_permit_starts_at > ? OR
             temporary_permit_starts_at IS ?',
            Date.today, nil
          )
          .where(
            'residence_permit_at <= ? OR
             residence_permit_at IS ?',
            Date.today, nil
          )
          .where(citizenship_at: nil)
      end

      # Anvisade barn 0–17 år:
      # * SKA ha ”Anvisningsdatum till Malmö” idag eller tidigare
      # * ”Utskriven till Malmö” SKA INTE ha inträffat senare än igår
      # FIXME: allow nils for dates?
      def assigned
        default
          .where(municipality_id: 135) # 135 is hard wired to "Malmö kommun, Srf"
          .where('municipality_placement_migrationsverket_at <= ?', Date.today)
          .where('checked_out_to_our_city < ?', Date.today)
      end

      # * SKA ha datum för ”TUT startar” och SKA ligga idag eller tidigare
      # * SKA ha datum för ”TUT slutar” och SKA INTE ha inträffat
      # * SKA ha datum för ”Utskriven till Malmö” i går eller tidigare
      # * TUT SKA vara längre än 12 månader
      # * SKA INTE ha datum för PUT som har inträffat
      def tut
        refugees = default.where('temporary_permit_starts_at <= ?', Date.today)
          .where('temporary_permit_ends_at > ?', Date.today)
          .where(municipality_id: 135) # 135 is hard wired to "Malmö kommun, Srf"
          .where('municipality_placement_migrationsverket_at <= ?', Date.today)
          .where('residence_permit_at > ? OR residence_permit_at IS ?', Date.today, nil)

        refugees.map do |refugee|
          refugee if 12.months.ago(refugee.temporary_permit_ends_at) > refugee.temporary_permit_starts_at
        end.compact
      end

      # * SKA ha startdatum för PUT som har inträffat
      # * SKA vara ”Utskriven till Malmö” i går eller tidigare
      # * SKA INTE ha datum för medborgarskap
      def put
        default
          .where('residence_permit_at <= ?', Date.today)
          .where(municipality_id: 135) # 135 is hard wired to "Malmö kommun, Srf"
          .where('municipality_placement_migrationsverket_at <= ?', Date.today)
          .where(citizenship_at: nil)
      end
    end
  end
end
