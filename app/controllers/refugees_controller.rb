class RefugeesController < ApplicationController
  protect_from_forgery except: :suggest

  def index
    # This view is for statistics
    @refugees = Refugee.count
    @genders = Gender.all.map { |g| "#{Refugee.where(gender: g).count} är #{g.name.downcase}" }.join(', ')
    @registered_last_seven_days = Refugee.where(registered: 7.days.ago..DateTime.now).count
    @genders_last_seven_days = Gender.all.map { |g| "#{Refugee.where(gender: g, registered: 7.days.ago..DateTime.now).count} är #{g.name.downcase}" }.join(', ')

    @without_placement = Refugee.includes(:placements).where(placements: { refugee_id: nil }).count
    @overlapping_placement = Placement.overlapping_by_refugee.count
    @overlapping_placement_last_seven_days = Placement.overlapping_by_refugee(placements_from: 170.days.ago.to_s, placements_to: Date.today.to_s).count

    @without_residence_permit = Refugee.where(residence_permit_at: nil).count
    @without_municipality_placement = Refugee.where(municipality: nil).count
    @deregistered = Refugee.where.not(deregistered: nil).count

    @top_countries = Refugee.joins(:countries).select('countries.name').group('countries.name').count('countries.name').sort_by{ |key, value| value }.reverse
    @top_countries_last_seven_days = Refugee.joins(:countries).where(registered: 7.days.ago..DateTime.now).select('countries.name').group('countries.name').count('countries.name').sort_by{ |key, value| value }.reverse

    @top_languages = Refugee.joins(:languages).select('languages.name').group('languages.name').count('languages.name').sort_by{ |key, value| value }.reverse
    @top_languages_last_seven_days = Refugee.joins(:languages).where(registered: 7.days.ago..DateTime.now).select('languages.name').group('languages.name').count('languages.name').sort_by{ |key, value| value }.reverse

    @homes = Home.count
    @seats = Home.sum(:seats)
    @guaranteed_seats = Home.sum(:guaranteed_seats)
    @movable_seats = Home.sum(:movable_seats)
    @total_placement_time = Placement.all.map(&:placement_time).inject(&:+)
  end

  def show
    @refugee = Refugee.find(params[:id])
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
    def load_more_query
      { page: params[:page].to_i + 1 }.merge(params.except(:controller, :action, :page))
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def refugee_params
      permitted_params = [
        :name, :registered, :deregistered, :deregistered_reason,
        :residence_permit_at,
        :municipality_id,
        :municipality_placement_migrationsverket_at,
        :municipality_placement_per_agreement_at,
        :municipality_placement_comment,
        :special_needs, :other_relateds, :comment,
        :gender_id,
        home_ids: [],
        country_ids: [],
        language_ids: [],
        ssns_attributes: [:id, :_destroy, :name],
        dossier_numbers_attributes: [:id, :_destroy, :name]
      ]
      permitted_params.unshift(:draft) if can? :manage, Refugee
      params.require(:refugee).permit(*permitted_params)
    end
end
