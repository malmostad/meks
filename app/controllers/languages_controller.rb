class LanguagesController < ApplicationController
  before_action :set_language, only: [:show, :edit, :update, :destroy]

  def index
    @languages = Language.order(:name)
  end

  def new
    @language = Language.new
  end

  def edit
  end

  def create
    @language = Language.new(language_params)

    if @language.save
      redirect_to languages_path, notice: 'Språket skapades'
    else
      render :new
    end
  end

  def update
    if @language.update(language_params)
      redirect_to languages_path, notice: 'Språket uppdaterades'
    else
      render :edit
    end
  end

  def destroy
    @language.destroy
    redirect_to languages_path, notice: 'Språket raderades'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_language
      @language = Language.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def language_params
      params.require(:language).permit(:name)
    end
end
