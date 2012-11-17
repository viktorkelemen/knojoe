class MessagesController < ApplicationController
  before_filter :require_login

  def create
    @chat = Chat.find(params[:chat_id])
    @message = @chat.messages.new(params[:message])
    @message.author = current_user

    if @message.save
      Pusher["channel_chat_#{@chat.id}"].trigger('chat_event', pusher_data)
      head :ok
    else
      render :text => "ng"
    end
  end

  def like
    @message = Message.find(params[:id])
    @like = Like.new(message: @message, user: current_user)
    if @like.save
      render json: { message_id: @message.id }
    else
      render json: { error: @like.errors.full_message }
    end
  end

  def unlike
    @message = Message.find(params[:id])
    @like = @message.like

    if @like.destroy
      render json: { message_id: @message.id }
    else
      render json: { error: @like.errors.full_message }
    end
  end
  private

  def pusher_data
    {
      message:   @message.content,
      author_id:    @message.author_id,
      # timestamp: @message.created_at.strftime("%Y/%m/%d %H:%m"),
      html:      render_to_string(partial: 'message', locals: { message: @message, check_role: false })
    }
  end
end
