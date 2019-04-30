module EconomyUppbokningReportHelper
  def expected_income(record)
    replace_rates = Economy::RatesForRefugee.new(
      record[:refugee], from: record[:from], to: record[:to]
    ).replace_rates

    sum_formula(
      record[:rates]&.map { |x| "#{x[:days]}*#{x[:amount]}" }&.compact&.join('+'),
      replace_rates.as_formula
    )
  end
end
