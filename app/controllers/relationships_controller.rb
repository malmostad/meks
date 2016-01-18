class RelationshipsController < ApplicationController
  before_action :set_refugee, only: [
    :index, :new, :create, :edit, :update, :destroy]
  before_action :set_relationship, only: [
    :edit, :update, :destroy]

  def index
    authorize! :read, @refugee => Relationship
  end

  def new
    @relationship = @refugee.relationships.new
    authorize! :create, @relationship
  end

  def edit
    authorize! :edit, @relationship
  end

  def create
    @relationship = @refugee.relationships.new(relationship_params)
    authorize! :create, @relationship

    if @relationship.save
      redirect_to @refugee, notice: 'Anhörigskapet registrerades'
    else
      render :new
    end
  end

  def update
    authorize! :update, @relationship

    if @relationship.update(relationship_params)
      redirect_to @refugee, notice: 'Anhörigskapet uppdaterades'
    else
      render :edit
    end
  end

  def destroy
    authorize! :destroy, @relationship

    @relationship.destroy
    redirect_to refugee_relationships_path(@refugee), notice: 'Anhörigskapet raderades'
  end

  private

    def authorize_action
      authorize! @refugee
    end

    def set_refugee
      @refugee = Refugee.find(params[:refugee_id])
    end

    def set_relationship
      id = params[:id] || params[:relationship_id]
      @relationship = @refugee.relationships.find(id)
    end

    def relationship_params
      params.require(:relationship).permit(
        :refugee_id,
        :related_id,
        :type_of_relationship_id
      )
    end
end
