module EconomyUppbokningReportHelper
  def expected_income(record)
    sum_formula(
      record[:rates]&.map { |x| "#{x[:days]}*#{x[:amount]}" }&.compact&.join('+'),
      # Special case, see class doc
      ::Economy::ReplaceRatesWithActualCosts.new(
        record[:refugee],
        from: record[:from],
        to: record[:to]
      ).as_formula
    )
  end
end
