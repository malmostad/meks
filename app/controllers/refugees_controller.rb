class RefugeesController < ApplicationController
  before_action :set_refugee, only: [:show, :edit, :update, :destroy]

  def index
    @refugees = Refugee.includes(:countries, :languages, :ssns, :gender, :dossier_numbers)
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
      redirect_to @refugee, notice: 'Ensamkommande flyktingbarn registrerat'
    else
      render :new
    end
  end

  def update
    if @refugee.update(refugee_params)
      redirect_to @refugee, notice: 'Ensamkommande flyktingbarn uppdaterades'
    else
      render :edit
    end
  end

  def destroy
    @refugee.destroy
    redirect_to refugees_url, notice: 'Ensamkommande flyktingbarn togs bort'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_refugee
      @refugee = Refugee.find(params[:id])
      @refugee.dossier_numbers << DossierNumber.new
      @refugee.ssns << Ssn.new
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
        ssn_ids: [],
        dossier_number_ids: [])
    end
end
