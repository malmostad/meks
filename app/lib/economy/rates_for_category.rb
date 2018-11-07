module Economy
  # Rates for rate category
  class RatesForCategory < Base
    def initialize(category, range = DEFAULT_DATE_RANGE)
      @category = category
      @range = range
    end

    def sum
      as_array.sum { |x| x[:days] * x[:amount] }
    end

    def as_formula
      as_array.map do |x|
        next if x.value? 0

        "#{x[:days]}*#{x[:amount]}"
      end.compact.join('+')
    end

    # Returns an array with hashes containing :refugee, :amount and :days
    def as_array
      @as_array ||= begin
        return [] if @category.qualifier.nil?

        @refugees_and_payments ||= Refugee.includes(:payments).all
        @refugees_and_payments.map do |refugee|
          rfr = RatesForRefugee.new(refugee, @range)

          # Get amount and days for the `refugee` in `category`
          arr = rfr.send(@category.qualifier[:meth], @category).compact!
          next if arr.blank?

          # The refugee instance is needed for sub-sheets in reports
          arr.map do |amount_and_days|
            amount_and_days = amount_and_days.merge(refugee: refugee)
            amount_and_days
          end
        end.flatten.compact
      end
    end
  end
end
