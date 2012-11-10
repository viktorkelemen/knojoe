class MessagesController < ApplicationController
  def create
    @chat = Chat.find(params[:chat_id])
    @message = @chat.messages.new(params[:message])

    if @message.save
      Pusher["channel-#{@chat.id}"].trigger('chat-event', {:message => @message.content})
      render :text => "ok"
    else
      render :text => "ng"
    end
  end
end
