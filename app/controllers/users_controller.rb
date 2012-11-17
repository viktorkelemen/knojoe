class UsersController < ApplicationController
  before_filter :require_login

  def show
    @chats = current_user.chats
  end
end