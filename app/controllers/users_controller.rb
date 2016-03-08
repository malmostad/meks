class UsersController < ApplicationController
  def index
    @users = User.order('last_login desc')
  end
end
