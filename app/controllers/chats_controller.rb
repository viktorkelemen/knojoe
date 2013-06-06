class ChatsController < ApplicationController
  before_filter :require_login
  before_filter :set_chat, except: [:new, :create]

  def new
  end

  def create
    @chat = Chat.new(params[:chat])
    @chat.requester = current_user
    @chat.messages.first.author = current_user

    if @chat.save
      Pusher["presence-home"].trigger('chat_start_event', pusher_data, params[:socket_id])
      @chat.messages.create(status: 'system', content: 'Waiting for the responder...')
      redirect_to requester_chat_path(@chat)
    else
      render 'new'
    end
  end

  def responder
    if @chat.responder && current_user != @chat.responder
      redirect_to root_path, alert: t('chats.responder_exists')
      return
    elsif current_user == @chat.requester
      redirect_to root_path
      return
    end

    # if responder joined
    unless @chat.started?
      @chat.start
      @chat.messages.create(status: 'system', content: 'responder joined.')
      Pusher["channel_chat_#{@chat.id}"].trigger('chat_status_event', { message: 'responder joined', type: 'join'})
      Pusher["channel_chat_#{@chat.id}"].trigger('chat_start_event', @chat.started_at.to_i);

      # sending all other responders that someone picked it up
      Pusher["presence-home"].trigger('chat_pickedup_event', {
        chat_id: @chat.id,
        message: "#{ @chat.first_message.try(:content) } - picked up",
        timestamp: Time.now.strftime("%H:%M"),
        type: 'pickedup'
      }, params[:socket_id])

    end

    if @chat.finished?
      redirect_to review_chat_path, alert: t('chats.chat_finished')
    end

    @chat.assign_responder(current_user)
    @messages = @chat.messages
  end

  def requester
    @messages = @chat.messages
  end

  def connection_timeout
    return head :bad_request if @chat.finished?

    # after requester send the request, and no responder respond in time
    message = @chat.messages.create!(status: 'system', content: 'No one picked up.')
    @chat.finish
    Pusher["channel_chat_#{@chat.id}"].trigger('chat_status_event', { message: message.content, type: 'timeout'})
    head :ok
  end

  def chat_timeout
    @chat.messages.create(status: 'system', content: 'Time is up, requester please press the thank you button and exit.')
    Pusher["channel_chat_#{@chat.id}"].trigger('chat_status_event', { message: 'Time is up, requester please press the thank you button and exit.', type: 'timeout' })
    head :ok
  end

  def finish
    @chat.finish
    @chat.messages.create(status: 'system', content: params[:message])
    Pusher["channel_chat_#{@chat.id}"].trigger('chat_status_event', { message: params[:message], type: 'finish' })
    head :ok
  end

  def review
    raise 'error' unless @chat.finished?
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

  def set_chat
    @chat = Chat.includes(messages: [:author]).find(params[:id])
  end

  def pusher_data
    {
      chat_id:      @chat.id,
      requester_id: @chat.requester.id,
      chat_path:    responder_chat_path(@chat),
      message:      @chat.first_message.try(:content),
      timestamp:    @chat.created_at.strftime("%H:%M"),
      type:         'new',
      active:       Chat.num_of_active_chats
    }
  end
end
