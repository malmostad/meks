module EconomyFollowupReportHelper
  def economy_per_month(person, age_group)
    (1..12).map do |month|
      interval_for_costs = age_cutoff(month, person, age_group, cost: true)

      # For this report only: don't calculate cost after citizenship_at - 1 day
      if person.citizenship_at?
        interval_for_costs[:to] = earliest_date(interval_for_costs[:to], person.citizenship_at - 1.day)
      end

      interval_for_income = age_cutoff(month, person, age_group)
      [
        days_with_placements(person, interval_for_costs),
        person_cost(person, interval_for_costs),
        person_expected_income(person, interval_for_income)
      ]
    end.flatten
  end

  def days_with_placements(person, interval)
    person.placements.map do |placement|
      count_from = latest_date(placement.moved_in_at, interval[:from])
      count_to = earliest_date(placement.moved_out_at, interval[:to])
      days = (count_to - count_from).to_i + 1

      days.negative? ? 0 : days
    end.compact.sum
  end

  def type_of_housings(person)
    person.placements.map do |placement|
      # Only this years placements
      next unless placement.moved_out_at.nil? ||
                  placement.moved_out_at >= Date.new(@year).beginning_of_year

      placement.home&.type_of_housings&.map(&:name)
    end.compact.join(', ')
  end

  private

  def age_cutoff(month, person, age_group, cost = false)
    date = Date.new(@year, month)
    from = date.beginning_of_month
    to = date.end_of_month

    return { from: from, to: to } unless person.date_of_birth

    if age_group == :children
      to = earliest_date(to, person.date_of_birth + 18.years - 1.day)
    elsif age_group == :adults
      from = latest_date(from, person.date_of_birth + 18.years)
      to = earliest_date(to, person.date_of_birth + 21.years - 1.day) unless cost
    end

    # Do only calculate cost up to 21st birthday unless deregistered is set
    if cost && person.will_turn_21_in_year(@year) && !person.deregistered
      to = earliest_date(to, person.date_at_21st_birthday)
    end

    { from: from, to: to }
  end
end
