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

  def asylum_status(refugee)
    asylum = refugee.asylum
    return 'Ingen status' if asylum.blank?

    I18n.t('simple_form.labels.refugee.' + asylum.first) + ' ' + asylum.second.to_s
  end

  def refugee_cost(refugee, interval, po_rates)
    sum_formula(
      ::Economy::PlacementAndHomeCost.new(refugee.placements, interval).as_formula,
      ::Economy::ExtraContributionCost.new(refugee, interval.merge(po_rates: po_rates)).as_formula,
      ::Economy::RefugeeExtraCost.new(refugee, interval).as_formula,
      ::Economy::PlacementExtraCost.new(
        refugee.placements, interval.merge(po_rates: po_rates)
      ).as_formula,
      ::Economy::FamilyAndEmergencyHomeCost.new(
        refugee.placements, interval.merge(po_rates: po_rates)
      ).as_formula
    )
  end

  def refugee_expected_income(refugee, interval, po_rates)
    sum_formula(
      ::Economy::RatesForRefugee.new(refugee, interval).as_formula,
      # Special case, see class doc
      ::Economy::ReplaceRatesWithActualCosts.new(
        refugee, interval.merge(po_rates: po_rates)
      ).as_formula
    )
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
