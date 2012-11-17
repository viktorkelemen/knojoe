class ChatsController < ApplicationController
  before_filter :require_login
  before_filter :find_chat, except: [:new, :create]

  def new
    @village = Village.find(params[:village_id])
  end

  def create
    @village = Village.find(params[:village_id])
    @chat = @village.chats.new(params[:chat])
    @chat.guest = current_user

    if @chat.save
      @village.villagers.each do |village|
        Pusher["channel_villager_#{village.id}"].trigger('chat_start_event', pusher_data)
      end

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

    # if villager joined
    unless @chat.started_at
      @chat.update_attributes!(started_at: Time.now)
      Pusher["channel_chat_#{@chat.id}"].trigger('chat_status_event', 'Villager joined.')
    end

    if @chat.finished_at
      render :text => "too late"
    end

    @chat.update_attributes!(villager: current_user)
    @messages = @chat.messages
  end

  def guest
    @messages = @chat.messages
  end

  def connection_timeout
    # after guest send the request, and no villager respond in time
    @chat.update_attributes!(finished_at: Time.now)
    head :ok
  end

  def chat_timeout
    Pusher["channel_chat_#{@chat.id}"].trigger('chat_status_event', 'Time is up, Guest please press the thank you button and exit.')
    head :ok
  end

  def finish
    @chat.update_attributes!(finished_at: Time.now)
    Pusher["channel_chat_#{@chat.id}"].trigger('chat_status_event', params[:message])
    head :ok
  end

  def review
    raise 'error' unless @chat.finished_at
    raise 'error' unless @chat.guest == current_user
    @messages = @chat.messages
  end

  def email
    ChatMailer.send_conversation(@chat, current_user, params[:email]).deliver
    redirect_to review_chat_path(@chat), notice: 'Sent!'
  end

  private

  def find_chat
    @chat = Chat.includes(messages: [:author]).find(params[:id])
  end

  def pusher_data
    {
      village_name: @village.name,
      chat_path:    villager_chat_path(@chat),
      message:      @chat.messages.first.content,
      timestamp:    @chat.created_at.strftime("%H:%m")
      # # timestamp: @message.created_at.strftime("%Y/%m/%d %H:%m"),
      # html:      render_to_string(partial: 'message', locals: { message: @message, check_role: false })
    }
  end
end
