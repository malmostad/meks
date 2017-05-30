class RefugeesController < ApplicationController
  def show
    @refugee = Refugee.includes(
      :placements,
      relationships: [:type_of_relationship, :related],
      placements: [:home, :moved_out_reason, :legal_code],
      payments: :payment_import
    ).find(params[:id])
  end

  def new
    @refugee = Refugee.new
    @refugee.placements.build
    @homes = Home.where(active: true)
  end

  def edit
    @refugee = Refugee.find(params[:id])
    authorize! :edit, @refugee
  end

  def create
    @refugee = Refugee.new(refugee_params)
    authorize! :create, @refugee

    @refugee.draft = true if current_user.has_role? :reader

    if @refugee.save
      redirect_to @refugee, notice: 'Ensamkommande barnet registrerat'
    else
      @homes = Home.where(active: true)
      render :new
    end
  end

  def update
    @refugee = Refugee.find(params[:id])
    authorize! :update, @refugee

    if @refugee.update(refugee_params)
      redirect_to @refugee, notice: 'Ensamkommande barnet uppdaterades'
    else
      render :edit
    end
  end

  def destroy
    Refugee.find(params[:id]).destroy
    redirect_to refugees_path, notice: 'Ärendet raderades'
  end

  # Full search for refugees
  def search
    @q = params[:q].present? ? params[:q].dup : ''

    @limit = 100
    @offset = params[:page].to_i * @limit
    @more_request = refugees_search_path(load_more_query)

    response = Refugee.fuzzy_search(params[:q], from: @offset, size: @limit)
    if response
      @refugees = response[:refugees]
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

  # Suggest refugees based on a search query
  def suggest
    @refugees = Refugee.fuzzy_suggest(params[:term])
    if @refugees
      @refugees = @refugees.map do |r|
        { id: r.id,
          name: r.name,
          path: "#{root_url}refugees/#{r.id}",
          dossier_number: r.dossier_number,
          ssn: r.ssn,
          value: [r.name, r.dossier_number, r.ssn].reject(&:blank?).join(', ')
        }
      end
    else
      @refugees = { error: 'Couldn’t get suggestions' }
    end

    if params['callback']
      render json: @refugees.to_json, callback: params['callback']
    else
      render json: @refugees
    end
  end

  def drafts
    @refugees = Refugee.where(draft: true)
    render :search
  end


  private

    def load_more_query
      { page: params[:page].to_i + 1 }.merge(params.except(:controller, :action, :page).to_h)
    end

    def refugee_params
      permitted_params = [
        :name, :registered, :deregistered, :deregistered_reason_id, :deregistered_comment,
        :date_of_birth,
        :ssn_extension,
        :dossier_number,
        :residence_permit_at,
        :checked_out_to_our_city,
        :temporary_permit_starts_at,
        :temporary_permit_ends_at,
        :secrecy,
        :sof_placement,
        :municipality_id,
        :municipality_placement_migrationsverket_at,
        :municipality_placement_per_agreement_at,
        :municipality_placement_comment,
        :social_worker,
        :special_needs, :other_relateds, :comment_id,
        :gender_id,
        :citizenship_at,
        home_ids: [],
        country_ids: [],
        language_ids: [],
        ssns_attributes: [:id, :_destroy, :date_of_birth, :extension],
        dossier_numbers_attributes: [:id, :_destroy, :name],
        placements_attributes: [:home_id, :moved_in_at, :legal_code_id]
      ]
      permitted_params.unshift(:draft) if can? :manage, Refugee
      params.require(:refugee).permit(*permitted_params)
    end
end
