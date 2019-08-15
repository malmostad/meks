# 'Extra kostnad för personer'
class PersonExtraCostsController < ApplicationController
  before_action :set_person, only: %i[new create edit update destroy]
  before_action :set_person_extra_cost, only: %i[edit update destroy]

  def new
    @person_extra_cost = @person.person_extra_costs.new
    authorize! :create, @person_extra_cost
  end

  def edit
    authorize! :edit, @person_extra_cost
  end

  def create
    @person_extra_cost = @person.person_extra_costs.new(person_extra_cost_params)
    authorize! :create, @person_extra_cost

    if @person_extra_cost.save
      redirect_to person_show_costs_path(@person), notice: 'Extra kostnaden registrerades'
    else
      render :new
    end
  end

  def update
    authorize! :update, @person_extra_cost

    if @person_extra_cost.update(person_extra_cost_params)
      redirect_to person_show_costs_path(@person), notice: 'Extra kostnaden uppdaterades'
    else
      render :edit
    end
  end

  def destroy
    PersonExtraCost.find(params[:id]).destroy
    redirect_to person_show_costs_path(@person), notice: 'Extra kostnaden raderades'
  end

  private

  def set_person
    @person = Person.find(params[:person_id])
  end

  def set_person_extra_cost
    @person = Person.find(params[:person_id])
    id = params[:id] || params[:person_extra_cost_id]
    @person_extra_cost = @person.person_extra_costs.find(id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def person_extra_cost_params
    params.require(:person_extra_cost).permit(
      :person_id,
      :date,
      :amount,
      :comment
    )
  end
end
