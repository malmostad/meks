module Economy
  # Rates for rate category
  class RatesForCategory < Base
    def initialize(category, interval = DEFAULT_INTERVAL)
      @category = category
      @interval = interval
    end

    # Returns an array with hashes containing :refugee, :amount and :days
    def as_array
      @as_array ||= begin
        return [] if @category.qualifier.nil?

        @refugees_and_payments ||= Refugee.includes(:payments).all
        @refugees_and_payments.map do |refugee|
          rfr = RatesForRefugee.new(refugee, @interval)

          # Get amount and days for the `refugee` in `category`
          arr = rfr.send(@category.qualifier[:meth], @category).reject(&:blank?)
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
