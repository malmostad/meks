class DeregisteredReasonsController < ApplicationController
  before_action :set_deregistered_reason, only: [:show, :edit, :update, :destroy]

  def index
    @deregistered_reasons = DeregisteredReason.order(:name)
  end

  def new
    @deregistered_reason = DeregisteredReason.new
  end

  def edit
  end

  def create
    @deregistered_reason = DeregisteredReason.new(deregistered_reason_params)

    if @deregistered_reason.save
      redirect_to deregistered_reasons_path, notice: 'Målgruppen skapades'
    else
      render :new
    end
  end

  def update
    if @deregistered_reason.update(deregistered_reason_params)
      redirect_to deregistered_reasons_path, notice: 'Målgruppen uppdaterades'
    else
      render :edit
    end
  end

  def destroy
    @deregistered_reason.destroy
    redirect_to deregistered_reasons_url, notice: 'Målgruppen raderades'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deregistered_reason
      @deregistered_reason = DeregisteredReason.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def deregistered_reason_params
      params.require(:deregistered_reason).permit(:name)
    end
end
