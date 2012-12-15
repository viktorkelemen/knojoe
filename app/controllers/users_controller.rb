class UsersController < ApplicationController
  before_filter :find_user, only: [:show, :helped, :asked]

  def index
    @users = User.order('received_likes_count DESC').limit(10)
  end

  def show
  end

  def asked
    @chats = @user.asked_questions

    render 'history'
  end

  def helped
    @chats = @user.helped_questions

    render 'history'
  end

  private

  def find_user
    @user = User.find(params[:id])
  end
end