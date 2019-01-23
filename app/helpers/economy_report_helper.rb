module EconomyReportHelper
  def cost(refugee, interval, po_rates)
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

  def expected_income(refugee, interval, po_rates)
    sum_formula(
      ::Economy::RatesForRefugee.new(refugee, interval).as_formula,
      # Special case, see class doc
      ::Economy::ReplaceRatesWithActualCosts.new(
        refugee, interval.merge(po_rates: po_rates)
      ).as_formula
    )
  end

  def payment(refugee, interval)
    sum_formula(::Economy::Payment.new(refugee.payments, interval).as_formula)
  end

  def payment_comments(refugee, interval)
    ::Economy::Payment.new(refugee.payments, interval).comments.join("\r\x0D\x0A")
  end
end
