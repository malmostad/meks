class HomesController < ApplicationController
  before_action :set_home, only: [:show, :edit, :update, :destroy]

  def index
    @homes = Home.includes(:type_of_housings, :owner_types, :target_groups, :languages).order(:name)
  end

  def show
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
        :postal_town, :seats, :guaranteed_seats, :movable_seats, :comment,
        language_ids: [],
        target_group_ids: [],
        owner_type_ids: [],
        type_of_housing_ids: [])
    end
end
