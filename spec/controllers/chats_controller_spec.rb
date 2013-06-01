require 'spec_helper'

describe ChatsController do
  describe '#create' do
    let(:user) { create(:user) }
    let(:chat) { Chat.last }
    let(:params) { { messages_attributes: { "0" => { content: 'hello' } } } }

    before do
      login(user)
      Pusher.stub_chain(:[], :trigger)
    end

    it 'creates chat object' do
      post :create, chat: params

      expect(chat).to be_present
    end

    it 'sets requester to current user' do
      post :create, chat: params

      expect(chat.requester).to eql(user)
    end

    it 'creates "waiting for the responder" system message' do
      post :create, chat: params

      message = chat.messages.last
      expect(message.content).to eq('Waiting for the responder...')
      expect(message.status).to eq('system')
    end

    it 'sets message author to current user' do
      post :create, chat: params

      expect(chat.messages[0].author).to eql(user)
    end

    it 'triggers chat_start_event with proper data' do
      # TODO hard coding chat id to "1".
      # can't get `chat` record since it's nil before `post :create`.
      Pusher['presence-home'].should_receive(:trigger).with('chat_start_event', {
        :chat_id=>1,
        :chat_path=>responder_chat_path(1),
        :message=>"#1 - hello",
        :timestamp=> Time.now.strftime("%H:%M"),
        :type=>"new",
        :active=>1
      }, nil)

      post :create, chat: params
    end
  end
end
