class MunicipalitiesController < ApplicationController
  before_action :set_municipalities, only: [:show, :edit, :update, :destroy]

  def index
    @municipalities = Municipality.order(:name)
  end

  def new
    @municipalities = Municipality.new
  end

  def edit
  end

  def create
    @municipalities = Municipality.new(municipalities_params)

    if @municipalities.save
      redirect_to municipalities_path, notice: 'Målgruppen skapades'
    else
      render :new
    end
  end

  def update
    if @municipalities.update(municipalities_params)
      redirect_to municipalities_path, notice: 'Målgruppen uppdaterades'
    else
      render :edit
    end
  end

  def destroy
    @municipalities.destroy
    redirect_to municipalities_url, notice: 'Målgruppen raderades'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_municipalities
      @municipalities = Municipality.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def municipalities_params
      params.require(:municipalities).permit(:name)
    end
end
