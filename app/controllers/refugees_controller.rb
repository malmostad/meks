class RefugeesController < ApplicationController
  before_action :set_refugee, only: [:show, :edit, :update, :destroy]

  protect_from_forgery except: :suggest

  def index
    @refugees = Refugee.order(:name).includes(
      :countries, :ssns, :dossier_numbers, :gender, :placements, :homes)
  end

  def show
  end

  def new
    @refugee = Refugee.new
    @refugee.dossier_numbers << DossierNumber.new
    @refugee.ssns << Ssn.new
  end

  def edit
  end

  def create
    @refugee = Refugee.new(refugee_params)

    if @refugee.save
      redirect_to @refugee, notice: 'Ensamkommande flyktingbarnet registrerat'
    else
      render :new
    end
  end

  def update
    if @refugee.update(refugee_params)
      redirect_to @refugee, notice: 'Ensamkommande flyktingbarnet uppdaterades'
    else
      render :edit
    end
  end

  def destroy
    @refugee.destroy
    redirect_to refugees_url, notice: 'Ensamkommande flyktingbarnet togs bort'
  end

  # Full search for refugees
  def search
    @q = params[:q].present? ? params[:q].dup : ''

    @limit = 10
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
          ssns: r.ssns || '',
          dossier_numbers: r.dossier_numbers || ''
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

  private
    def load_more_query
      { page: params[:page].to_i + 1 }.merge(params.except(:controller, :action, :page))
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_refugee
      @refugee = Refugee.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def refugee_params
      params.require(:refugee).permit(
        :name, :registered, :deregistered, :deregistered_reason,
        :residence_permit_at,
        :municipality_id,
        :municipality_placement_migrationsverket_at,
        :municipality_placement_per_agreement_at,
        :municipality_placement_comment,
        :special_needs, :comment,
        :gender_id,
        home_ids: [],
        country_ids: [],
        language_ids: [],
        ssns_attributes: [:id, :_destroy, :name],
        dossier_numbers_attributes: [:id, :_destroy, :name]
      )
    end
end
