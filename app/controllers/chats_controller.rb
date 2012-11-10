class ChatsController < ApplicationController
  def new
    @chat = Chat.create!
    redirect_to guest_chat_path(@chat)
  end

  def villager
    @chat = Chat.find(params[:id])
  end

  def guest
    @chat = Chat.find(params[:id])
  end
end
