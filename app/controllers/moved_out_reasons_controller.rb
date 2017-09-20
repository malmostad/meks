class MovedOutReasonsController < ApplicationController
  before_action :set_moved_out_reason, only: [:show, :edit, :update, :destroy]

  def index
    @moved_out_reasons = MovedOutReason.order(:name)
  end

  def new
    @moved_out_reason = MovedOutReason.new
  end

  def edit
  end

  def create
    @moved_out_reason = MovedOutReason.new(moved_out_reason_params)

    if @moved_out_reason.save
      redirect_to moved_out_reasons_path, notice: 'Målgruppen skapades'
    else
      render :new
    end
  end

  def update
    if @moved_out_reason.update(moved_out_reason_params)
      redirect_to moved_out_reasons_path, notice: 'Målgruppen uppdaterades'
    else
      render :edit
    end
  end

  def destroy
    @moved_out_reason.destroy
    redirect_to moved_out_reasons_path, notice: 'Målgruppen raderades'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_moved_out_reason
      @moved_out_reason = MovedOutReason.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def moved_out_reason_params
      params.require(:moved_out_reason).permit(:name)
    end
end
