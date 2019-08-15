module ReportHelper
  def heading_comment(sheet, col, comment, row = 1)
    sheet.add_comment(ref: "#{col}#{row}", text: comment, author: '', visible: false)
  end

  def sum_formula(*arr)
    arr.flatten!
    arr&.reject!(&:blank?)
    return '=(0)' if arr.blank?

    "=(#{arr.join('+')})"
  end

  def asylum_status(person)
    asylum = person.asylum
    return 'Ingen status' if asylum.blank?

    I18n.t('simple_form.labels.person.' + asylum.first) + ' ' + asylum.second.to_s
  end

  def person_cost(person, interval)
    sum_formula(
      ::Economy::PlacementAndHomeCost.new(person.placements, interval).as_formula,
      ::Economy::ExtraContributionCost.new(person, interval).as_formula,
      ::Economy::PersonExtraCost.new(person, interval).as_formula,
      ::Economy::PlacementExtraCost.new(person.placements, interval).as_formula,
      ::Economy::FamilyAndEmergencyHomeCost.new(person.placements, interval).as_formula
    )
  end

  def person_expected_income(person, interval)
    sum_formula(
      ::Economy::RatesForPerson.new(person, interval).as_formula,
      ::Economy::OneTimePayment.new(person, interval).as_formula
    )
  end

  def placement_names_within_range(person, interval)
    placements_within_range(person, interval).map do |pl|
      "#{pl.home.name} (#{pl.moved_in_at}–#{pl.moved_out_at})"
    end.join(', ')
  end

  def legal_codes_within_range(person, interval)
    placements_within_range(person, interval)
      .map(&:legal_code)
      .try(:map, &:name).join(', ')
  end

  # Filter out placements within the report range without add additional queries
  def placements_within_range(person, interval)
    person.placements.map do |placement|
      if placement.moved_in_at <= interval[:to].to_date &&
         (placement.moved_out_at.nil? || placement.moved_out_at >= interval[:from].to_date)
        next placement
      end
    end.compact.sort_by(&:moved_in_at)
  end

  def step_sum(row, range, step)
    range.step(step).map { |x| "#{Axlsx.col_ref(x)}#{row}" }.join('+')
  end

  def earliest_date(*dates)
    dates.flatten.compact.map(&:to_date).min
  end

  def latest_date(*dates)
    dates.flatten.compact.map(&:to_date).max
  end
end
