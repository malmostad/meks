# TODO: implement authorization

class LoginController < ApplicationController
  #  TODO: remove
  protect_from_forgery with: :null_session, only: :ok

  layout 'login'

  def index
  end

  def ok
    redirect_to controller: :refugees, action: :index
  end

  def nope
  end
end
