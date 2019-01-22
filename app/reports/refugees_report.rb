# rr = RefugeesReport.new(registered_from: "2019-01-01", registered_to: "2019-01-22", born_after: "2001-01-22", born_before: "2019-01-22")
class RefugeesReport < ApplicationReport
  def initialize(options = {})
    @registered_from = options[:registered_from]
    @registered_to = options[:registered_to]
    @born_after = options[:born_after]
    @born_before = options[:born_before]
    @include_without_date_of_birth = options[:include_without_date_of_birth]
    @asylum = options[:asylum]

    options[:locals] = { refugees: records.to_a }
    options[:report_name] = 'Ensamkommande barn'
    options[:first_sheetname] = "#{options[:registered_from]}–#{options[:registered_to]}"
    super(options)
  end

  def records
    refugees = Refugee.includes(
      :countries, :languages, :ssns, :dossier_numbers,
      :gender, :homes, :municipality, :deregistered_reason,
      relationships: %i[type_of_relationship refugee],
      inverse_relationships: %i[type_of_relationship refugee],
      current_placements: [home: :type_of_housings]
    )

    if @registered_from.present? && @registered_to.present?
      refugees = refugees.where(registered: @registered_from..@registered_to)
    end

    query = [(@born_after..@born_before)]
    query << nil if @include_without_date_of_birth

    refugees = refugees.where(date_of_birth: query) if @born_after.present? && @born_before.present?

    if @asylum.present?
      query = []

      query << 'refugees.residence_permit_at is not null' if @asylum.include? 'put'
      query << 'refugees.temporary_permit_starts_at is not null' if @asylum.include? 'tut'
      query << 'refugees.municipality_id is not null' if @asylum.include? 'municipality'
      refugees = refugees.where(query.join(' or '))
    end
    refugees
  end
end
