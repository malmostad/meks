class GendersController < ApplicationController
  before_action :set_gender, only: [:show, :edit, :update, :destroy]

  def index
    @genders = Gender.order(:name)
  end

  def new
    @gender = Gender.new
  end

  def edit
  end

  def create
    @gender = Gender.new(gender_params)

    if @gender.save
      redirect_to genders_path, notice: 'Könet skapades'
    else
      render :new
    end
  end

  def update
    if @gender.update(gender_params)
      redirect_to genders_path, notice: 'Könet uppdaterades'
    else
      render :edit
    end
  end

  def destroy
    @gender.destroy
    redirect_to genders_path, notice: 'Könet raderades'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gender
      @gender = Gender.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def gender_params
      params.require(:gender).permit(:name)
    end
end
