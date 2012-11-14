class MessagesController < ApplicationController
  def create
    @chat = Chat.find(params[:chat_id])
    @message = @chat.messages.new(params[:message])
    @message.author = current_user

    if @message.save
      Pusher["channel_#{@chat.id}"].trigger('chat_event', pusher_data)
      head :ok
    else
      render :text => "ng"
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
