module EconomyFollowupReportHelper
  def economy_per_month(refugee, age_group, po_rates)
    (1..12).map do |month|
      interval = age_cutoff(month, refugee, age_group)
      [
        days(refugee, month),
        refugee_cost(refugee, interval, po_rates),
        refugee_expected_income(refugee, interval, po_rates)
      ]
    end.flatten
  end

  # TODO: implement
  def days(refugee, month)
    Time.days_in_month(month, @year)
  end

  def type_of_housings(refugee)
    refugee.placements.map do |placement|
      # Only this years placements
      next unless placement.moved_out_at.nil? ||
                  placement.moved_out_at >= Date.new(@year).beginning_of_year

      placement.home&.type_of_housings&.map(&:name)
    end.compact.join(', ')
  end

  private

  def age_cutoff(month, refugee, age_group, cut_of_upper = true)
    date = Date.new(@year, month)
    from = date.beginning_of_month
    to = date.end_of_month

    if age_group == :children
      to = earliest_date(to, refugee.date_of_birth + 18.years - 1.day)
    else
      from = latest_date(from, refugee.date_of_birth + 18.years)
      # FIXME: use the new CSN age calculation
      to = earliest_date(to, refugee.date_of_birth + 21.years - 1.day) if cut_of_upper
    end

    { from: from, to: to }
  end
end
