module EconomyFollowupReportHelper
  def economy_per_month(refugee)
    (1..12).map do |month|
      [
        days(refugee, month),
        cost(refugee, month),
        expected_income(refugee, month)
      ]
    end.flatten
  end

  # TODO: implement
  def days(refugee, month)
    Time.days_in_month(month, @year)
  end

  # TODO: implement
  def cost(refugee, month)
    '=(0)'
  end

  # TODO: implement
  def expected_income(refugee, month)
    '=(0)'
  end
end
