class ChatsController < ApplicationController
  before_filter :require_login
  before_filter :set_chat, except: [:new, :create]

  def new
  end

  def create
    @chat = Chat.new(params[:chat])
    @chat.requester = current_user
    @chat.messages.first.author = current_user unless @chat.messages.empty?

    if @chat.save
      Pusher["presence-home"].trigger('chat_start_event', {
        chat_id: @chat.id,
        requester_id: @chat.requester.id,
        chat_path: responder_chat_path(@chat),
        message: @chat.first_message.try(:content),
        html: render_to_string(partial: '/home/dashboard_message', locals: { chat: @chat }),
        timestamp: @chat.created_at.strftime("%H:%M"),
        type: 'new',
        active: Chat.num_of_active_chats
      }, params[:socket_id])
      @chat.messages.create(status: 'system', content: 'Waiting for the responder.')

      log_event('Chat', 'chat created', "chat id #{@chat.id}")

      redirect_to requester_chat_path(@chat)
    else
      redirect_to ask_path, alert: 'Please input your question.'
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
      message = @chat.messages.create(status: 'system', content: 'Responder joined.')

      Pusher["channel_chat_#{@chat.id}"].trigger('chat_status_event', {
        message: message.content,
        html: render_to_string(partial: '/messages/message', locals: { message: message, check_role: false }),
        type: 'join'
      })

      Pusher["channel_chat_#{@chat.id}"].trigger('chat_start_event', @chat.started_at.to_i);

      # sending all other responders that someone picked it up
      Pusher["presence-home"].trigger('chat_pickedup_event', {
        chat_id: @chat.id,
        message: "#{ @chat.first_message.try(:content) } - picked up",
        timestamp: Time.zone.now.strftime("%H:%M"),
        type: 'pickedup'
      }, params[:socket_id])

      log_event('Chat', 'chat started', "chat id #{@chat.id}")
    end

    if @chat.finished?
      redirect_to review_chat_path, alert: t('chats.chat_finished')
      return
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
    Pusher["channel_chat_#{@chat.id}"].trigger('chat_status_event', {
      message: message.content,
      html: render_to_string(partial: '/messages/message', locals: { message: message, check_role: false }),
      type: 'timeout'
    })

    log_event('Chat', 'connection timeout', "chat id #{@chat.id}")

    head :ok
  end

  def chat_timeout
    message = @chat.messages.create(
      status: 'system',
      content: 'Time is up, requester please press the thank you button and exit.'
    )

    Pusher["channel_chat_#{@chat.id}"].trigger('chat_status_event', {
      message: message.content,
      html:  render_to_string(partial: '/messages/message', locals: { message: message, check_role: false }),
      type: 'timeout'
    })

    log_event('Chat', 'chat timeout', "chat id #{@chat.id}")

    head :ok
  end

  def finish
    @chat.finish
    message = @chat.messages.create(status: 'system', content: params[:message])
    Pusher["channel_chat_#{@chat.id}"].trigger('chat_status_event', {
      message: message.content,
      html: render_to_string(partial: '/messages/message', locals: { message: message, check_role: false }),
      type: 'finish'
    })

    log_event('Chat', 'finished', "chat id #{@chat.id}")

    head :ok
  end

  def review
    return redirect_to root_path unless @chat.finished? && current_user.participated?(@chat)
    @messages = @chat.messages
  end

  def email
    if params[:review][:email] == current_user.masked_email
      email = current_user.email
    else
      email = params[:review][:email]
    end
    ChatMailer.send_conversation(@chat, current_user, email).deliver

    log_event('Chat', 'email sent', "chat id #{@chat.id}")

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

end
