class RefugeesController < ApplicationController
  protect_from_forgery except: :suggest

  def show
    @refugee = Refugee.find(params[:id])
    @latest_event = latest_event
  end

  def new
    @refugee = Refugee.new
    @refugee.dossier_numbers << DossierNumber.new
    @refugee.ssns << Ssn.new
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
      @refugees = @refugees.map { |r|
        { id: r.id,
          name: r.name,
          path: "#{root_url}refugees/#{r.id}",
          ssns: r.ssns.split(/\s/) || [],
          dossier_numbers: r.dossier_numbers.split(/\s/) || []
        }
      }
    else
      @refugees = { error: "Couldn't get suggestions"}
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
    def latest_event
      events = {}

      %w(
        registered residence_permit_at
        temporary_permit_starts_at temporary_permit_ends_at
        municipality_placement_migrationsverket_at
        municipality_placement_per_agreement_at
      ).each do |event|
        events[event.to_s] = @refugee.send(event.to_s)
      end

      events = events.delete_if { |key, value| value.blank? }
      last_event = Hash[events.sort_by{|k, v| v}.reverse].first

      @placement_is_latest = last_event.include?('municipality_placement_migrationsverket_at') ||
        last_event.include?('municipality_placement_per_agreement_at')

      if last_event.nil?
        last_event = ['Ingen händelse', '']
      end
      last_event
    end

    def load_more_query
      { page: params[:page].to_i + 1 }.merge(params.except(:controller, :action, :page))
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def refugee_params
      permitted_params = [
        :name, :registered, :deregistered, :deregistered_reason,
        :residence_permit_at,
        :temporary_permit_starts_at,
        :temporary_permit_ends_at,
        :municipality_id,
        :municipality_placement_migrationsverket_at,
        :municipality_placement_per_agreement_at,
        :municipality_placement_comment,
        :special_needs, :other_relateds, :comment,
        :gender_id,
        home_ids: [],
        country_ids: [],
        language_ids: [],
        ssns_attributes: [:id, :_destroy, :date_of_birth, :extension],
        dossier_numbers_attributes: [:id, :_destroy, :name]
      ]
      permitted_params.unshift(:draft) if can? :manage, Refugee
      params.require(:refugee).permit(*permitted_params)
    end
end
