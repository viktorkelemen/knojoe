class ChatsController < ApplicationController
  def new
  end

  def create
    @chat = Chat.new(params[:chat])
    if @chat.save
      redirect_to guest_chat_path(@chat)
    else
      render :text => "ERROR"
    end
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
