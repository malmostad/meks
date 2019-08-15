class PlacementsController < ApplicationController
  before_action :set_person, only: [
    :new, :create]
  before_action :set_placement, only: [
    :edit, :move_out, :update, :move_out_update, :destroy]

  def new
    @placement = @person.placements.new
    @pre_selected = default_legal_code

    authorize! :create, @placement
  end

  def edit
    @pre_selected = @placement.legal_code_id || default_legal_code
    authorize! :edit, @placement
  end

  def move_out
    authorize! :edit, @placement
  end

  def create
    @placement = @person.placements.new(placement_params)
    authorize! :create, @placement

    if @placement.save
      redirect_to person_show_placements_path(@person), notice: 'Placeringen registrerades'
    else
      render :new
    end
  end

  def update
    authorize! :update, @placement

    if @placement.update(placement_params)
      redirect_to person_show_placements_path(@person), notice: 'Placeringen uppdaterades'
    else
      render :edit
    end
  end

  def move_out_update
    authorize! :edit, @placement
    if @placement.update(placement_params)
      redirect_to person_show_placements_path(@person), notice: 'Placeringen uppdaterades'
    else
      render :move_out
    end
  end

  def destroy
    Placement.find(params[:id]).destroy
    redirect_to person_show_placements_path(@person), notice: 'Placeringen raderades'
  end

  private

  def set_person
    @person = Person.find(params[:person_id])
    @homes = Home.where(active: true)
  end

  def set_placement
    @person = Person.find(params[:person_id])
    id = params[:id] || params[:placement_id]
    @placement = @person.placements.find(id)
    @homes = Home.where(active: true)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def placement_params
    params.require(:placement).permit(
      :home_id, :person_id, :moved_in_at, :moved_out_at, :moved_out_reason_id,
      :legal_code_id, :specification, :cost,
      placement_extra_costs_attributes: %i[id _destroy date amount comment],
      family_and_emergency_home_costs_attributes: %i[id _destroy period_start period_end
        expense fee contractor_name contractor_birthday contactor_employee_number]
    )
  end
end
