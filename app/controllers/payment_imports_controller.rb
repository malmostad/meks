class PaymentImportsController < ApplicationController
  def index
    @payment_imports = PaymentImport.includes(:user).order('imported_at desc')
  end

  def show
    @payment_import = PaymentImport.includes(:user).find(params[:id])
  end

  def new
    @payment_import = PaymentImport.new
  end

  def create
    file = payment_import_params['file']

    @payment_import = PaymentImport.new
    @payment_import.parse(file, current_user)

    if @payment_import.save
      redirect_to payment_imports_path, notice: 'Importen sparades'
    else
      render :new
    end
  end

  def destroy
    @payment_import = PaymentImport.find(params[:id])
    @payment_import.destroy
    redirect_to payment_imports_path, notice: 'Importen och alla kostnadsfält raderades'
  end

  private

  def payment_import_params
    params.require(:payment_import).permit(:file)
  end

  rescue_from ActionController::ParameterMissing do
    redirect_to new_payment_import_path, alert: 'Glömde du välja fil?'
  end
end
