class MunicipalitiesController < ApplicationController
  before_action :set_municipality, only: [:edit, :update, :destroy]

  def index
    @municipalities = Municipality.order(:name)
  end

  def new
    @municipality = Municipality.new
  end

  def edit
  end

  def create
    @municipality = Municipality.new(municipality_params)

    if @municipality.save
      redirect_to municipalities_path, notice: 'Kommunen skapades'
    else
      render :new
    end
  end

  def update
    if @municipality.update(municipality_params)
      redirect_to municipalities_path, notice: 'Kommunen uppdaterades'
    else
      render :edit
    end
  end

  def destroy
    @municipality.destroy
    redirect_to municipalities_url, notice: 'Kommunen raderades'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_municipality
    @municipality = Municipality.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def municipality_params
    params.require(:municipality).permit(:name, :our_municipality)
  end
end
