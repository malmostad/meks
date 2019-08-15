class EconomyReport < ApplicationReport::Base
  def initialize(params = {})
    @params = params
    @interval = { from: params[:from], to: params[:to] }

    options = {}
    options[:locals] = { people: people }
    super(options.merge(params))
  end

  def people
    people = Person.includes(
      :countries, :languages, :ssns, :dossier_numbers, :gender, :municipality,
      :person_extra_costs, :deregistered_reason, :payments,
      extra_contributions: [:extra_contribution_type],
      placements: [
        :moved_out_reason, :legal_code, :placement_extra_costs,
        :family_and_emergency_home_costs,
        home: %i[owner_type target_groups languages type_of_housings costs]
      ]
    ).references(:placements)

    filter_people(people)
  end

  private

  # Filter away people that have no costs, income or payments during the @interval
  def filter_people(people)
    people.map do |person|
      costs_and_rates = [
        ::Economy::PlacementAndHomeCost.new(person.placements, @interval).sum,
        ::Economy::ExtraContributionCost.new(person, @interval).sum,
        ::Economy::PersonExtraCost.new(person, @interval).sum,
        ::Economy::PlacementExtraCost.new(person.placements, @interval).sum,
        ::Economy::FamilyAndEmergencyHomeCost.new(person.placements, @interval).sum,
        ::Economy::RatesForPerson.new(person, @interval).sum,
        ::Economy::Payment.new(person.payments, @interval).sum,
        ::Economy::OneTimePayment.new(person, @interval).sum
      ].reject(&:blank?).sum

      next if costs_and_rates.zero?

      person
    end.compact
  end
end
