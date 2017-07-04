class LegalCodesController < ApplicationController
  before_action :set_legal_code, only: [:show, :edit, :update, :destroy]

  def index
    @legal_codes = LegalCode.order(:name)
  end

  def new
    @legal_code = LegalCode.new
  end

  def edit
  end

  def create
    @legal_code = LegalCode.new(legal_code_params)

    if @legal_code.save
      redirect_to legal_codes_path, notice: 'Lagrummet skapades'
    else
      render :new
    end
  end

  def update
    if @legal_code.update(legal_code_params)
      redirect_to legal_codes_path, notice: 'Lagrummet uppdaterades'
    else
      render :edit
    end
  end

  def destroy
    @legal_code.destroy
    redirect_to legal_codes_url, notice: 'Lagrummet raderades'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_legal_code
      @legal_code = LegalCode.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def legal_code_params
      params.require(:legal_code).permit(:name, :pre_selected)
    end
end
