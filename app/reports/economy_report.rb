class EconomyReport < ApplicationReport::Base
  def initialize(params = {})
    @params = params
    @interval = { from: params[:from], to: params[:to] }
    @po_rates = PoRate.all

    options = {}
    options[:locals] = { refugees: refugees, po_rates: @po_rates }
    super(options.merge(params))
  end

  def refugees
    refugees = Refugee.includes(
      :countries, :languages, :ssns, :dossier_numbers, :gender, :municipality,
      :refugee_extra_costs, :deregistered_reason, :payments,
      extra_contributions: [:extra_contribution_type],
      placements: [
        :moved_out_reason, :legal_code, :placement_extra_costs,
        :family_and_emergency_home_costs,
        home: %i[owner_type target_groups languages type_of_housings costs]
      ]
    ).references(:placements)

    filter_refugees(refugees)
  end

  private

  # Filter away refugees that have no costs, income or payments during the @interval
  def filter_refugees(refugees)
    refugees.map do |refugee|
      costs_and_rates = [
        ::Economy::PlacementAndHomeCost.new(refugee.placements, @interval).sum,
        ::Economy::ExtraContributionCost.new(refugee, @interval.merge(po_rates: @po_rates)).sum,
        ::Economy::RefugeeExtraCost.new(refugee, @interval).sum,
        ::Economy::PlacementExtraCost.new(refugee.placements, @interval.merge(po_rates: @po_rates)).sum,
        ::Economy::FamilyAndEmergencyHomeCost.new(refugee.placements, @interval.merge(po_rates: @po_rates)).sum,
        ::Economy::RatesForRefugee.new(refugee, @interval).sum,
        ::Economy::ReplaceRatesWithActualCosts.new(refugee, @interval.merge(po_rates: @po_rates)).sum,
        ::Economy::Payment.new(refugee.payments, @interval).sum
      ].sum

      next if costs_and_rates.zero?

      refugee
    end.compact
  end
end
