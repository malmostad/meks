class ExtraContributionsController < ApplicationController
  before_action :set_refugee, only: %i[new create edit update destroy]
  before_action :set_extra_contribution, only: %i[edit update destroy]

  def new
    @extra_contribution = @refugee.extra_contributions.new
    authorize! :create, @extra_contribution
  end

  def edit
    authorize! :edit, @extra_contribution
  end

  def create
    @extra_contribution = @refugee.extra_contributions.new(extra_contribution_params)
    authorize! :create, @extra_contribution

    if @extra_contribution.save
      redirect_to @refugee, notice: 'Extra insatsen registrerades'
    else
      render :new
    end
  end

  def update
    authorize! :update, @extra_contribution

    if @extra_contribution.update(extra_contribution_params)
      redirect_to @refugee, notice: 'Extra insatsen uppdaterades'
    else
      render :edit
    end
  end

  def destroy
    ExtraContribution.find(params[:id]).destroy
    redirect_to @refugee, notice: 'Extra insatsen raderades'
  end

  private

  def set_refugee
    @refugee = Refugee.find(params[:refugee_id])
  end

  def set_extra_contribution
    @refugee = Refugee.find(params[:refugee_id])
    id = params[:id] || params[:extra_contribution_id]
    @extra_contribution = @refugee.extra_contributions.find(id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def extra_contribution_params
    params.require(:extra_contribution).permit(
      :refugee_id,
      :extra_contribution_type_id,
      :period_start,
      :period_end,
      :fee,
      :expense,
      :contractor_name,
      :contractor_birthday,
      :contactor_employee_number
    )
  end
end
