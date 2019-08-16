class PeopleController < ApplicationController
  def show
    @person = Person.find(params[:id])
  end

  def show_placements
    @person = Person.includes(
      :placements,
      placements: [:family_and_emergency_home_costs, :moved_out_reason,
                   :legal_code, :placement_extra_costs, { home: :costs }]
    ).find(params[:person_id])
  end

  def show_costs
    @person = Person.includes(
      extra_contributions: :extra_contribution_type
    ).find(params[:person_id])
  end

  def show_relateds
    @person = Person.includes(
      relationships: [:type_of_relationship, :related]
    ).find(params[:person_id])
  end

  def show_economy
    @person = Person.includes(
      :placements,
      placements: [:family_and_emergency_home_costs, :legal_code,
                   :placement_extra_costs, { home: :costs }],
      extra_contributions: :extra_contribution_type,
      payments: :payment_import
    ).find(params[:person_id])
  end

  def new
    @person = Person.new
    @person.placements.build
    @homes = Home.where(active: true)
    @pre_selected = default_legal_code
  end

  def edit
    @person = Person.find(params[:id])
    authorize! :edit, @person
  end

  def create
    @person = Person.new(person_params)
    authorize! :create, @person

    @person.draft = true if current_user.has_role? :reader

    if @person.save
      redirect_to @person, notice: 'Personen registrerades'
    else
      @homes = Home.where(active: true)
      render :new
    end
  end

  def update
    @person = Person.find(params[:id])
    authorize! :update, @person

    if @person.update(person_params)
      redirect_to @person, notice: 'Personen uppdaterades'
    else
      render :edit
    end
  end

  def destroy
    Person.find(params[:id]).destroy
    redirect_to people_path, notice: 'Ärendet raderades'
  end

  # Full search for people
  def search
    @q = params[:q].present? ? params[:q].dup : ''

    @limit = 100
    @offset = params[:page].to_i * @limit
    @more_request = people_search_path(load_more_query)

    @drafts_count = Person.where(draft: true).count
    @imported_count = Person.where.not(imported_at: nil).count

    response = Person.fuzzy_search(params[:q], from: @offset, size: @limit)
    if response
      @people = response[:people]
      @total = response[:total]
      logger.info { "Elasticsearch took #{response[:took]}ms" }
    end
    @has_more = @total.present? ? (@offset + @limit < @total) : false
    if request.xhr?
      @xhr = true
      render :_search_results, layout: false
    else
      render :search
    end
  end

  # Suggest people based on a search query
  def suggest
    @people = Person.fuzzy_suggest(params[:term])
    if @people
      @people = @people.map do |r|
        { id: r.id,
          name: r.name,
          path: person_path(r.id),
          dossier_number: r.dossier_number,
          ssn: r.ssn,
          procapita: r.procapita,
          value: [r.name, r.dossier_number, r.ssn, r.procapita].reject(&:blank?).join(', ')
        }
      end
    else
      @people = { error: 'Couldn’t get suggestions' }
    end

    if params['callback']
      render json: @people.to_json, callback: params['callback']
    else
      render json: @people
    end
  end

  def drafts
    @drafts_count = Person.where(draft: true).count
    @imported_count = Person.where.not(imported_at: nil).count
    @people = Person.where(draft: true)
    render :search
  end

  def imported
    @drafts_count = Person.where(draft: true).count
    @imported_count = Person.where.not(imported_at: nil).count
    @people = Person.where.not(imported_at: nil)
    render :search
  end

  private

  def load_more_query
    {
      page: params[:page].to_i + 1, q: params[:q], utf8: '✓'
    }
  end

  def person_params
    permitted_params = [
      :ekb, :name, :registered, :deregistered, :deregistered_reason_id, :deregistered_comment,
      :date_of_birth,
      :ssn_extension,
      :dossier_number,
      :residence_permit_at,
      :checked_out_to_our_city,
      :temporary_permit_starts_at,
      :temporary_permit_ends_at,
      :secrecy,
      :sof_placement,
      :arrival,
      :municipality_id,
      :transferred,
      :municipality_placement_migrationsverket_at,
      :municipality_placement_comment,
      :social_worker,
      :special_needs, :other_relateds, :comment_id,
      :gender_id,
      :citizenship_at,
      :procapita,
      home_ids: [],
      country_ids: [],
      language_ids: [],
      ssns_attributes: [:id, :_destroy, :date_of_birth, :extension],
      dossier_numbers_attributes: [:id, :_destroy, :name],
      placements_attributes: [:home_id, :person_id, :moved_in_at,
      :legal_code_id, :specification, :cost]
    ]
    permitted_params.unshift(:draft) if can? :manage, Person
    params.require(:person).permit(*permitted_params)
  end
end
