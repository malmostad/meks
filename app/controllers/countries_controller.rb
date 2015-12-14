class CountriesController < ApplicationController
  before_action :set_country, only: [:show, :edit, :update, :destroy]

  def index
    @countries = Country.order(:name)
  end

  def new
    @country = Country.new
  end

  def edit
  end

  def create
    @country = Country.new(country_params)

    if @country.save
      redirect_to countries_path, notice: 'Landet skapades'
    else
      render :new
    end
  end

  def update
    if @country.update(country_params)
      redirect_to countries_path, notice: 'Landet uppdaterades'
    else
      render :edit
    end
  end

  def destroy
    @country.destroy
    redirect_to countries_path, notice: 'Landet raderades'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_country
      @country = Country.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def country_params
      params.require(:country).permit(:name)
    end
end
