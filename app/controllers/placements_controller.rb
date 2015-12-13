class PlacementsController < ApplicationController
  def index
    @placements = Placement.order('name')
  end

  def new
    @refugee = Refugee.find(params[:refugee_id])
    @refugee.placement = Placement.new
  end

  def edit
    @refugee = Refugee.find(params[:refugee_id])
    @refugee.placement = @refugee.placement.find(params[:id])
  end

  def create
    @refugee = Refugee.find(params[:refugee_id])
    @refugee.placement = @refugee.placements.new(placement_params)

    if @refugee.placement.save
      redirect_to @refugee, notice: 'Placeringen registrerades'
    else
      render :new
    end
  end

  def update
    @refugee = Refugee.find(params[:refugee_id])
    @refugee.placement = @refugee.placements.find(params[:id])
    if @refugee.placement.update(placement_params)
      redirect_to @refugee, notice: 'Placeringen uppdaterades'
    else
      render :edit
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def placement_params
      params.require(:placement).permit(
        :home_id, :refugee_id, :moved_in_at, :moved_out_at,
        :moved_out_reason_id, :comment
      )
    end
end
