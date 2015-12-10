class OwnerTypesController < ApplicationController
  before_action :set_owner_type, only: [:show, :edit, :update, :destroy]

  def index
    @owner_types = OwnerType.all
  end

  def new
    @owner_type = OwnerType.new
  end

  def edit
  end

  def create
    @owner_type = OwnerType.new(owner_type_params)

    if @owner_type.save
      redirect_to owner_types_path, notice: 'Ägarformen skapades'
    else
      render :new
    end
  end

  def update
    if @owner_type.update(owner_type_params)
      redirect_to owner_types_path, notice: 'Ägarformen uppdaterades'
    else
      render :edit
    end
  end

  def destroy
    @owner_type.destroy
    redirect_to owner_types_path, notice: 'Ägerformen raderades'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_owner_type
      @owner_type = OwnerType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def owner_type_params
      params.require(:owner_type).permit(:name)
    end
end
