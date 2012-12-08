class UsersController < ApplicationController
  def index
    @users = User.order('received_likes_count DESC').limit(10)
  end
  def show
    @user = User.find(params[:id])
  end
end