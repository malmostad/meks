class TypeOfRelationshipsController < ApplicationController
  before_action :set_type_of_relationship, only: [:show, :edit, :update, :destroy]

  def index
    @type_of_relationships = TypeOfRelationship.order(:name)
  end

  def new
    @type_of_relationship = TypeOfRelationship.new
  end

  def edit
  end

  def create
    @type_of_relationship = TypeOfRelationship.new(type_of_relationship_params)

    if @type_of_relationship.save
      redirect_to type_of_relationships_path, notice: 'Boendeformen skapades'
    else
      render :new
    end
  end

  def update
    if @type_of_relationship.update(type_of_relationship_params)
      redirect_to type_of_relationships_path, notice: 'Boendeformen uppdaterades'
    else
      render :edit
    end
  end

  def destroy
    @type_of_relationship.destroy
    redirect_to type_of_relationships_path, notice: 'Boendeformen raderades'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_type_of_relationship
      @type_of_relationship = TypeOfRelationship.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def type_of_relationship_params
      params.require(:type_of_relationship).permit(:name)
    end
end
