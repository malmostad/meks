class HomesController < ApplicationController
  before_action :set_home, only: [:edit, :update, :destroy]

  def index
    @homes = Home.includes(:type_of_housings, :owner_type,
      :target_groups).order(:name)
  end

  def show
    @home = Home.includes(:owner_type, :target_groups, :languages, :placements,
      placements: { refugee: [:gender, :countries, :dossier_numbers, :ssns] }).find(params[:id])
  end

  def new
    @home = Home.new
  end

  def edit
  end

  def create
    @home = Home.new(home_params)

    if @home.save
      redirect_to @home, notice: 'Boendet skapades'
    else
      render :new
    end
  end

  def update
    if @home.update(home_params)
      redirect_to @home, notice: 'Boendet uppdaterades'
    else
      render :edit
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_home
      @home = Home.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def home_params
      params.require(:home).permit(
        :name, :phone, :fax, :address, :post_code,
        :postal_town, :guaranteed_seats, :movable_seats, :active, :comment,
        :owner_type_id,
        language_ids: [],
        target_group_ids: [],
        type_of_housing_ids: [])
    end
end
