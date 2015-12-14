class TargetGroupsController < ApplicationController
  before_action :set_target_group, only: [:show, :edit, :update, :destroy]

  def index
    @target_groups = TargetGroup.order(:name)
  end

  def new
    @target_group = TargetGroup.new
  end

  def edit
  end

  def create
    @target_group = TargetGroup.new(target_group_params)

    if @target_group.save
      redirect_to target_groups_path, notice: 'Målgruppen skapades'
    else
      render :new
    end
  end

  def update
    if @target_group.update(target_group_params)
      redirect_to target_groups_path, notice: 'Målgruppen uppdaterades'
    else
      render :edit
    end
  end

  def destroy
    @target_group.destroy
    redirect_to target_groups_url, notice: 'Målgruppen raderades'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_target_group
      @target_group = TargetGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def target_group_params
      params.require(:target_group).permit(:name)
    end
end
