module EconomyUppbokningReportHelper
  def expected_income(record)
    sum_formula(
      ::Economy::RatesForRefugee.new(
        record[:refugee], from: record[:from], to: record[:to]
      ).as_formula
    )
  end
end
