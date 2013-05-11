class HomeController < ApplicationController
  def index
    @recent_chats = Chat.recent

    @chat = Chat.new
    @chat.messages.new
  end

  def hook
    webhook = Pusher::WebHook.new(request)
    if webhook.valid?
      webhook.events.each do |event|
        case event["name"]
        when 'channel_occupied'
          puts "Channel occupied: #{event["channel"]}"
        when 'channel_vacated'
          puts "Channel vacated: #{event["channel"]}"
        end
      end
      render text: 'ok'
    else
      render text: 'invalid', status: 401
    end
  end

  def pusher_auth
    head :ok
  end
end