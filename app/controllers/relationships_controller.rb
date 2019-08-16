class RelationshipsController < ApplicationController
  before_action :set_person, only: [
    :index, :new, :create, :edit, :update, :destroy]
  before_action :set_relationship, only: [
    :edit, :update, :destroy]

  def index
    authorize! :read, @person => Relationship
  end

  def new
    @relationship = @person.relationships.new
    authorize! :create, @relationship
  end

  def edit
    authorize! :edit, @relationship
  end

  def create
    @relationship = @person.relationships.new(relationship_params)
    authorize! :create, @relationship

    if @relationship.save
      redirect_to person_show_relateds_path(@person), notice: 'Anhörigskapet registrerades'
    else
      render :new
    end
  end

  def update
    authorize! :update, @relationship

    if @relationship.update(relationship_params)
      redirect_to person_show_relateds_path(@person), notice: 'Anhörigskapet uppdaterades'
    else
      render :edit
    end
  end

  def destroy
    authorize! :destroy, @relationship

    @relationship.destroy
    redirect_to person_show_relateds_path(@person), notice: 'Anhörigskapet raderades'
  end

  private

    def set_person
      @person = Person.find(params[:person_id])
    end

    def set_relationship
      id = params[:id] || params[:relationship_id]
      @relationship = @person.relationships.find(id)
    end

    def relationship_params
      params.require(:relationship).permit(
        :person_id,
        :related_id,
        :type_of_relationship_id
      )
    end
end
