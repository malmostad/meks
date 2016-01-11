class UsersController < ApplicationController
  def index
    @users = User.order(:last_login)
  end
end
