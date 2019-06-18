module Economy
  # "Engångsintäkt för anvisning för ensamkommande"
  class OneTimePayment < Base
    def initialize(refugee, interval = DEFAULT_INTERVAL)
      @refugee = refugee
      @from = interval[:from].to_date
      @to = interval[:to].to_date
    end

    # Return the one_time_payment amount if it qualifies
    def sum
      return unless @refugee&.municipality&.our_municipality?
      return if @refugee.transferred?
      return unless @refugee.municipality_placement_migrationsverket_at&.between?(@from, @to)

      ::OneTimePayment.where('start_date <= ? and end_date >= ?', @to, @from).last&.amount
    end

    def as_formula
      sum.to_s
    end
  end
end
