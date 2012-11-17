class ChatsController < ApplicationController
  before_filter :require_login
  before_filter :find_chat, only: [:villager, :guest]

  def new
    @village = Village.find(params[:village_id])
  end

  def create
    @village = Village.find(params[:village_id])
    @chat = @village.chats.new(params[:chat])
    @chat.guest = current_user

    if @chat.save
      redirect_to guest_chat_path(@chat)
    else
      render 'new'
    end
  end

  def villager
    if @chat.villager && current_user != @chat.villager
      redirect_to root_path, alert: t('chats.villager_exists')
      return
    end

    @chat.update_attributes!(villager: current_user)
    @messages = @chat.messages
  end

  def guest
    @messages = @chat.messages
  end

  private

  def find_chat
    @chat = Chat.includes(messages: [:author]).find(params[:id])
  end
end
