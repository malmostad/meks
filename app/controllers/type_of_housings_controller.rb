class TypeOfHousingsController < ApplicationController
  before_action :set_type_of_housing, only: [:show, :edit, :update, :destroy]

  def index
    @type_of_housings = TypeOfHousing.all
  end

  def new
    @type_of_housing = TypeOfHousing.new
  end

  def edit
  end

  def create
    @type_of_housing = TypeOfHousing.new(type_of_housing_params)

    if @type_of_housing.save
      redirect_to type_of_housings_path, notice: 'Boendeformen skapades'
    else
      render :new
    end
  end

  def update
    if @type_of_housing.update(type_of_housing_params)
      redirect_to type_of_housings_path, notice: 'Boendeformen uppdaterades'
    else
      render :edit
    end
  end

  def destroy
    @type_of_housing.destroy
    redirect_to type_of_housings_path, notice: 'Boendeformen raderades'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_type_of_housing
      @type_of_housing = TypeOfHousing.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def type_of_housing_params
      params.require(:type_of_housing).permit(:name)
    end
end
