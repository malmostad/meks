class PeopleReport < ApplicationReport::Base
  def initialize(params = {})
    @params = params

    options = {}
    options[:from] = params[:registered_from]
    options[:to] = params[:registered_to]
    options[:locals] = { people: people }
    super(options.merge(params))
  end

  def people
    query = Person.includes(
      :countries, :languages, :ssns, :dossier_numbers,
      :gender, :homes, :municipality, :deregistered_reason,
      relationships: %i[type_of_relationship person],
      inverse_relationships: %i[type_of_relationship person],
      current_placements: [home: :type_of_housings]
    )

    if @params[:registered_from].present? && @params[:registered_to].present?
      query = query.where(registered: @params[:registered_from]..@params[:registered_to])
    end

    dob = [(@params[:born_after]..@params[:born_before])]
    dob << nil if @params[:include_without_date_of_birth]

    query = query.where(date_of_birth: dob) if @params[:born_after].present? &&
                                               @params[:born_before].present?

    if @params[:asylum].present?
      sql = []

      sql << 'people.residence_permit_at is not null' if @params[:asylum].include? 'put'
      sql << 'people.temporary_permit_starts_at is not null' if @params[:asylum].include? 'tut'
      sql << 'people.municipality_id is not null' if @params[:asylum].include? 'municipality'
      query = query.where(sql.join(' or '))
    end
    query
  end
end
