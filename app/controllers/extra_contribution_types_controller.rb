class ExtraContributionTypesController < ApplicationController
  before_action :set_extra_contribution_type, only: [:show, :edit, :update, :destroy]

  def index
    @extra_contribution_types = ExtraContributionType.order(:name)
  end

  def new
    @extra_contribution_type = ExtraContributionType.new
  end

  def edit
  end

  def create
    @extra_contribution_type = ExtraContributionType.new(extra_contribution_type_params)

    if @extra_contribution_type.save
      redirect_to extra_contribution_types_path, notice: 'Insatsformen skapades'
    else
      render :new
    end
  end

  def update
    if @extra_contribution_type.update(extra_contribution_type_params)
      redirect_to extra_contribution_types_path, notice: 'Insatsformen uppdaterades'
    else
      render :edit
    end
  end

  def destroy
    @extra_contribution_type.destroy
    redirect_to extra_contribution_types_path, notice: 'Insatsformen raderades'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_extra_contribution_type
      @extra_contribution_type = ExtraContributionType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def extra_contribution_type_params
      params.require(:extra_contribution_type).permit(:name, :outpatient)
    end
end
