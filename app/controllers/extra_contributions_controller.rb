class ExtraContributionsController < ApplicationController
  before_action :set_person, only: %i[new create edit update destroy]
  before_action :set_extra_contribution, only: %i[edit update destroy]

  def new
    @extra_contribution = @person.extra_contributions.new
    authorize! :create, @extra_contribution
  end

  def edit
    authorize! :edit, @extra_contribution
  end

  def create
    @extra_contribution = @person.extra_contributions.new(extra_contribution_params)
    authorize! :create, @extra_contribution

    if @extra_contribution.save
      redirect_to person_show_costs_path(@person), notice: 'Insatsen registrerades'
    else
      render :new
    end
  end

  def update
    authorize! :update, @extra_contribution

    if @extra_contribution.update(extra_contribution_params)
      redirect_to person_show_costs_path(@person), notice: 'Insatsen uppdaterades'
    else
      render :edit
    end
  end

  def destroy
    ExtraContribution.find(params[:id]).destroy
    redirect_to person_show_costs_path(@person), notice: 'Insatsen raderades'
  end

  private

  def set_person
    @person = Person.find(params[:person_id])
  end

  def set_extra_contribution
    @person = Person.find(params[:person_id])
    id = params[:id] || params[:extra_contribution_id]
    @extra_contribution = @person.extra_contributions.find(id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def extra_contribution_params
    params.require(:extra_contribution).permit(
      :person_id,
      :extra_contribution_type_id,
      :period_start,
      :period_end,
      :fee,
      :expense,
      :contractor_name,
      :contractor_birthday,
      :contactor_employee_number,
      :monthly_cost,
      :comment
    )
  end
end
