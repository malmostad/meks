module EconomyFollowupReportHelper
  def economy_per_month(refugee, age_group, po_rates)
    (1..12).map do |month|
      interval_for_costs = age_cutoff(month, refugee, age_group, cost: true)
      interval_for_income = age_cutoff(month, refugee, age_group)
      [
        days_with_placements(refugee, interval_for_costs),
        refugee_cost(refugee, interval_for_costs, po_rates),
        refugee_expected_income(refugee, interval_for_income, po_rates)
      ]
    end.flatten
  end

  def days_with_placements(refugee, interval)
    refugee.placements.map do |placement|
      count_from = latest_date(placement.moved_in_at, interval[:from])
      count_to = earliest_date(placement.moved_out_at, interval[:to])
      days = (count_to - count_from).to_i + 1

      days.negative? ? 0 : days
    end.compact.sum
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

  def age_cutoff(month, refugee, age_group, cost = false)
    date = Date.new(@year, month)
    from = date.beginning_of_month
    to = date.end_of_month

    return { from: from, to: to } unless refugee.date_of_birth

    if age_group == :children
      to = earliest_date(to, refugee.date_of_birth + 18.years - 1.day)
    elsif age_group == :adults
      from = latest_date(from, refugee.date_of_birth + 18.years)
      # FIXME: use the new CSN age calculation
      # For adults, costs are calculated even if they are older than the upper limits
      to = earliest_date(to, refugee.date_of_birth + 21.years - 1.day) unless cost
    end

    { from: from, to: to }
  end
end
