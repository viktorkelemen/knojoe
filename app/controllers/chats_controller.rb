class ChatsController < ApplicationController
  def new
    @chat = Chat.create!
    redirect_to guest_chat_path(@chat)
  end

  def villager
    @chat = Chat.find(params[:id])
    @messages = @chat.messages
  end

  def guest
    @chat = Chat.find(params[:id])
    @messages = @chat.messages
  end
end
