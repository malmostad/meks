module Economy
  # "Engångsintäkt för anvisning för personer"
  class OneTimePayment < Base
    def self.all(interval)
      Person
        .joins(:municipality)
        .where(municipalities: { our_municipality: true })
        .where('transferred = ? or transferred is ?', false, nil)
        .where('municipality_placement_migrationsverket_at between ? and ? ', interval[:from], interval[:to])
    end

    def initialize(person, interval = { from: Date.new(0), to: Date.today })
      @person = person
      @from = interval[:from].to_date
      @to = interval[:to].to_date
    end

    # Return the one_time_payment amount if it qualifies
    def sum
      return unless @person.ekb?
      return unless @person&.municipality&.our_municipality?
      return if @person.transferred?
      return unless @person.municipality_placement_migrationsverket_at&.between?(@from, @to)

      ::OneTimePayment.where('start_date <= ? and end_date >= ?', @to, @from).last&.amount
    end

    def as_formula
      sum.to_s
    end
  end
end
