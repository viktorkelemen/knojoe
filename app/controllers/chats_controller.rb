class ChatsController < ApplicationController
  before_filter :require_login
  before_filter :find_chat, except: [:new, :create]

  def new
  end

  def create
    @chat = Chat.new(params[:chat])
    @chat.requester = current_user

    if @chat.save
      # User.all.each do |user|
      #   Pusher["channel_user_#{user.id}"].trigger('chat_start_event', pusher_data)
      # end
      Pusher["presence-home"].trigger('chat_start_event', pusher_data)
      @chat.messages.create(status: 'system', content: 'Waiting for the villagers...')
      redirect_to requester_chat_path(@chat)
    else
      render 'new'
    end
  end

  def responder
    if @chat.responder && current_user != @chat.responder
      redirect_to root_path, alert: t('chats.responder_exists')
      return
    end

    # if responder joined
    unless @chat.started_at
      @chat.update_attributes!(started_at: Time.now)
      @chat.messages.create(status: 'system', content: 'responder joined.')
      Pusher["channel_chat_#{@chat.id}"].trigger('chat_status_event', { message: 'responder joined', type: 'join'})
      Pusher["channel_chat_#{@chat.id}"].trigger('chat_start_event', @chat.started_at.to_i);

      # sending all other responders that someone picked it up
      Pusher["presence-home"].trigger('chat_pickedup_event', {
        chat_id: @chat.id,
        message: "##{@chat.id} - picked up",
        timestamp: Time.now.strftime("%H:%m"),
        type: 'pickedup'
      })

    end

    #if @chat.finished_at
      #render :text => "too late"
    #end

    @chat.update_attributes!(responder: current_user)
    @messages = @chat.messages
  end

  def requester
    @messages = @chat.messages
  end

  def connection_timeout
    # after requester send the request, and no responder respond in time
    @chat.update_attributes!(finished_at: Time.now)
    head :ok
  end

  def chat_timeout
    @chat.messages.create(status: 'system', content: 'Time is up, requester please press the thank you button and exit.')
    Pusher["channel_chat_#{@chat.id}"].trigger('chat_status_event', { message: 'Time is up, requester please press the thank you button and exit.', type: 'timeout' })
    head :ok
  end

  def finish
    @chat.update_attributes!(finished_at: Time.now)
    @chat.messages.create(status: 'system', content: params[:message])
    Pusher["channel_chat_#{@chat.id}"].trigger('chat_status_event', { message: params[:message], type: 'finish' })
    head :ok
  end

  def review
    raise 'error' unless @chat.finished_at
    raise 'error' unless @chat.requester == current_user || @chat.responder == current_user
    @messages = @chat.messages
  end

  def email
    ChatMailer.send_conversation(@chat, current_user, params[:email]).deliver
    redirect_to review_chat_path(@chat), notice: 'Sent!'
  end

  def status
    Pusher["channel_chat_#{@chat.id}"].trigger('chat_typing_event', params[:status], params[:socket_id])
    head 200
  end

  private

  def find_chat
    @chat = Chat.includes(messages: [:author]).find(params[:id])
  end

  def pusher_data
    {
      chat_id:      @chat.id,
      chat_path:    responder_chat_path(@chat),
      message:      "##{@chat.id} - #{@chat.messages.first.content}",
      timestamp:    @chat.created_at.strftime("%H:%m"),
      type:         'new'
      # # timestamp: @message.created_at.strftime("%Y/%m/%d %H:%m"),
      # html:      render_to_string(partial: 'message', locals: { message: @message, check_role: false })
    }
  end
end
