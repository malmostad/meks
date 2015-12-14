class RefugeesController < ApplicationController
  before_action :set_refugee, only: [:show, :edit, :update, :destroy]

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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_refugee
      @refugee = Refugee.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def refugee_params
      params.require(:refugee).permit(
        :name, :registered, :deregistered, :deregistered_reason,
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
