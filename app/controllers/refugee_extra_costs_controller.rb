# 'Extra kostnad för barn'
class RefugeeExtraCostsController < ApplicationController
  before_action :set_refugee, only: %i[new create edit update destroy]
  before_action :set_refugee_extra_cost, only: %i[edit update destroy]

  def new
    @refugee_extra_cost = @refugee.refugee_extra_costs.new
    authorize! :create, @refugee_extra_cost
  end

  def edit
    authorize! :edit, @refugee_extra_cost
  end

  def create
    @refugee_extra_cost = @refugee.refugee_extra_costs.new(refugee_extra_cost_params)
    authorize! :create, @refugee_extra_cost

    if @refugee_extra_cost.save
      redirect_to @refugee, notice: 'Extra kostnaden registrerades'
    else
      render :new
    end
  end

  def update
    authorize! :update, @refugee_extra_cost

    if @refugee_extra_cost.update(refugee_extra_cost_params)
      redirect_to @refugee, notice: 'Extra kostnaden uppdaterades'
    else
      render :edit
    end
  end

  def destroy
    RefugeeExtraCost.find(params[:id]).destroy
    redirect_to @refugee, notice: 'Extra kostnaden raderades'
  end

  private

  def set_refugee
    @refugee = Refugee.find(params[:refugee_id])
  end

  def set_refugee_extra_cost
    @refugee = Refugee.find(params[:refugee_id])
    id = params[:id] || params[:refugee_extra_cost_id]
    @refugee_extra_cost = @refugee.refugee_extra_costs.find(id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def refugee_extra_cost_params
    params.require(:refugee_extra_cost).permit(
      :refugee_id,
      :date,
      :amount,
      :comment
    )
  end
end
