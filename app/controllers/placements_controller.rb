class PlacementsController < ApplicationController
  before_action :set_refugee, only: [
    :new, :create, :edit, :move_out, :update, :move_out_update, :destroy]
  before_action :set_placement, only: [
    :edit, :move_out, :update, :move_out_update, :destroy]

  def new
    @placement = @refugee.placements.new
    authorize! :create, @placement
  end

  def edit
    authorize! :edit, @placement
  end

  def move_out
    authorize! :edit, @placement
  end

  def create
    @placement = @refugee.placements.new(placement_params)
    authorize! :create, @placement

    if @placement.save
      redirect_to @refugee, notice: 'Placeringen registrerades'
    else
      render :new
    end
  end

  def update
    authorize! :update, @placement
    if @placement.update(placement_params)
      redirect_to @refugee, notice: 'Placeringen uppdaterades'
    else
      render :edit
    end
  end

  def move_out_update
    authorize! :edit, @placement
    if @placement.update(placement_params)
      redirect_to @refugee, notice: 'Placeringen uppdaterades'
    else
      render :move_out
    end
  end

  private
    def set_refugee
      @refugee = Refugee.find(params[:refugee_id])
      @homes = Home.where(active: true)
    end

    def set_placement
      @refugee = Refugee.find(params[:refugee_id])
      id = params[:id] || params[:placement_id]
      @placement = @refugee.placements.find(id)
      @homes = Home.where(active: true)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def placement_params
      allowed = [:home_id, :refugee_id, :moved_in_at, :moved_out_at, :moved_out_reason_id]
      begin
        home = @homes.find(params[:placement][:home_id])
        allowed += [:specification] if home && home.use_placement_specification
      rescue
      end
      params.require(:placement).permit(allowed)
    end
end
