class MessagesController < ApplicationController
  def create
    @chat = Chat.find(params[:chat_id])
    @message = @chat.messages.new(params[:message])
    @message.author = current_user

    if @message.save
      Pusher["channel_#{@chat.id}"].trigger('chat_event', { message: @message.content, author: @message.author_id, timestamp: @message.created_at.strftime("%Y/%m/%d %H:%m") })
      render json: { html: render_to_string(partial: 'message', locals: {message: @message}) }
    else
      render :text => "ng"
    end
  end
end
