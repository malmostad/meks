class OneTimePaymentsController < ApplicationController
  before_action :set_one_time_payment, only: [:edit, :update, :destroy]

  def index
    @one_time_payments = OneTimePayment.all
  end

  def new
    @one_time_payment = OneTimePayment.new
  end

  def edit
  end

  def create
    @one_time_payment = OneTimePayment.new(one_time_payment_params)

    if @one_time_payment.save
      redirect_to one_time_payments_path, notice: 'Engångsintäkten skapades'
    else
      render :new
    end
  end

  def update
    if @one_time_payment.update(one_time_payment_params)
      redirect_to one_time_payments_path, notice: 'Engångsintäkten uppdaterades'
    else
      render :edit
    end
  end

  def destroy
    @one_time_payment.destroy
    redirect_to one_time_payments_path, notice: 'Engångsintäkten raderades'
  end

  private

  def set_one_time_payment
    @one_time_payment = OneTimePayment.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def one_time_payment_params
    params.require(:one_time_payment).permit(
      :amount, :start_date, :end_date
    )
  end
end
