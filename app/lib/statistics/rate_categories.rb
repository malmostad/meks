module Statistics
  # TODO: Remove class and use Rates for 'ögonblicksbilder' instead?
  # Refugee rate categories (schabloner)
  class RateCategories < Refugee
    def self.refugees_per_category
      amount_and_range.map do |category|
        Statistics::RateCategories.send category[:name].to_sym
      end
    end

    # Returns an array of hashes with categories and their rates
    def self.amount_and_range
      RateCategory.includes(:rates).map do |category|
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

    def self.arrival_0_17
      age_0_17.arrival
    end

    def self.assigned_0_17
      age_0_17.assigned
    end

    def self.tut_0_17
      age_0_17.tut
    end

    def self.tut_18_20
      age_18_20.tut
    end

    def self.put_0_17
      age_0_17.put
    end

    def self.put_18_20
      age_18_20.put
    end

    def self.age_0_17
      default.where('date_of_birth > ?', 18.years.ago)
    end

    def self.age_18_20
      default.where('date_of_birth <= ? and date_of_birth > ?', 18.years.ago, 21.years.ago)
    end

    # * SKA INTE ha datum för ”Avslutad” som har inträffat
    def self.default
      where('deregistered > ?  OR deregistered IS ?', Date.today, nil)
    end

    # Ankomstbarn
    # * SKA ha inskrivningsdatum idag eller tidigare
    # * SKA INTE ha ”Anvisningsdatum” som har inträffat
    # * SKA INTE ha TUT som inträffat
    # * SKA INTE ha PUT som inträffat
    # * SKA INTE ha medborgarskap
    def self.arrival
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

    # * SKA ha ”Anvisningsdatum till Malmö” idag eller tidigare
    # * ”Utskriven till Malmö” SKA INTE ha inträffat senare än igår
    def self.assigned
      default
        .where(municipality_id: 135)
        .where('municipality_placement_migrationsverket_at <= ?', Date.today)
        .where('checked_out_to_our_city < ?', Date.today)
    end

    # * SKA ha datum för ”TUT startar” och SKA ligga idag eller tidigare
    # * SKA ha datum för ”TUT slutar” och SKA INTE ha inträffat
    # * SKA ha datum för ”Utskriven till Malmö” i går eller tidigare
    # * TUT SKA vara längre än 12 månader
    # * SKA INTE ha datum för PUT som har inträffat
    def self.tut
      refugees = default.where('temporary_permit_starts_at <= ?', Date.today)
        .where('temporary_permit_ends_at > ?', Date.today)
        .where(municipality_id: 135)
        .where('municipality_placement_migrationsverket_at <= ?', Date.today)
        .where('residence_permit_at > ? OR residence_permit_at IS ?', Date.today, nil)

      refugees.map do |refugee|
        refugee if 12.months.ago(refugee.temporary_permit_ends_at) > refugee.temporary_permit_starts_at
      end.compact
    end

    # * SKA ha startdatum för PUT som har inträffat
    # * SKA vara ”Utskriven till Malmö” i går eller tidigare
    # * SKA INTE ha datum för medborgarskap
    # TODO: Utskriven till Malmö is date for checked_out_to_our_city and not municipality_id
    def self.put
      default
        .where('residence_permit_at <= ?', Date.today)
        .where(municipality_id: 135)
        .where('municipality_placement_migrationsverket_at <= ?', Date.today)
        .where(citizenship_at: nil)
    end
  end
end
