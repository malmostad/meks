class RateCategoriesController < ApplicationController
  before_action :set_rate_category, only: [:edit, :update]

  def index
    @rate_categories = RateCategory.order(:name)
  end

  def edit
  end

  def update
    if @rate_category.update(rate_category_params)
      redirect_to rate_categories_path, notice: 'Schablonen uppdaterades'
    else
      render :edit
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rate_category
      @rate_category = RateCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rate_category_params
      params.require(:rate_category).permit(
        :name, :from_age, :to_age, :legal_code_id,
        rates_attributes: [:id, :_destroy, :amount, :start_date, :end_date]
      )
    end
end
