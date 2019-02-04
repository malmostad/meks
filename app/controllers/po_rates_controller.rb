class PoRatesController < ApplicationController
  before_action :set_po_rate, only: [:edit, :update, :destroy]

  def index
    @po_rates = PoRate.all
  end

  def new
    @po_rate = PoRate.new
  end

  def edit
  end

  def create
    @po_rate = PoRate.new(po_rate_params)

    if @po_rate.save
      redirect_to po_rates_path, notice: 'Arbetsgivaravgiften skapades'
    else
      render :new
    end
  end

  def update
    if @po_rate.update(po_rate_params)
      redirect_to po_rates_path, notice: 'Arbetsgivaravgiften uppdaterades'
    else
      render :edit
    end
  end

  def destroy
    @po_rate.destroy
    redirect_to po_rates_path, notice: 'Arbetsgivaravgiften raderades'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_po_rate
    @po_rate = PoRate.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def po_rate_params
    params.require(:po_rate).permit(
      :rate_under_65, :rate_between_65_and_81, :rate_from_82, :start_date, :end_date
    )
  end
end
