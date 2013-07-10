require 'spec_helper'

describe ChatsController do
  before do
    Pusher.stub_chain(:[], :trigger)
  end

  describe '#create' do
    let(:user) { create(:user) }
    let(:chat) { Chat.last }
    let(:params) { { messages_attributes: { "0" => { content: 'hello' } } } }

    before do
      login(user)
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
      expect(message.content).to eq('Waiting for the responder.')
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
        :message=>"hello",
        :requester_id=>1,
        :timestamp=> Time.zone.now.strftime("%H:%M"),
        :type=>"new",
        :active=>1
      }, nil)

      post :create, chat: params
    end
  end

  describe '#responder' do
    let!(:chat) { create(:chat) }
    let(:responder) { create(:user) }

    before do
      login(responder)
    end

    it 'assigns responder to the chat' do
      get :responder, id: chat

      expect(chat.reload.responder).to eql(responder)
    end

    it 'starts the chat' do
      get :responder, id: chat

      expect(chat.reload).to be_started
    end

    it 'creates a system message telling responder just joined' do
      get :responder, id: chat

      message = chat.reload.messages.last
      expect(message.content).to eq('Responder joined.')
      expect(message.status).to eq('system')
    end

    it 'triggers chat_pickup_event' do
      Pusher["channel_chat_#{chat.id}"].should_receive(:trigger).with('chat_status_event',
        message: 'Responder joined.',
        html: anything,
        type: 'join')
      Pusher["channel_chat_#{chat.id}"].should_receive(:trigger).with('chat_start_event', anything)
      Pusher['presence-home'].should_receive(:trigger).with('chat_pickedup_event', anything, '12345')

      get :responder, id: chat, socket_id: '12345'
    end

    it 'shows "responder already exists" message if another user accesses the page' do
      chat.assign_responder(responder)
      another_user = login

      get :responder, id: chat

      expect(flash[:alert]).to eq(I18n.t('chats.responder_exists'))
    end

    it 'redirects back to top page if requester tries to pick his/her own question' do
      login(chat.requester)

      get :responder, id: chat

      expect(response).to redirect_to(root_path)
    end

    it 'shows chat already finished message if it does' do
      Chat.any_instance.should_receive(:started?).and_return(true)
      Chat.any_instance.should_receive(:finished?).and_return(true)

      get :responder, id: chat

      expect(flash[:alert]).to eq(I18n.t('chats.chat_finished'))
    end

    it 'redirects to review page if chat already finished' do
      Chat.any_instance.should_receive(:started?).and_return(true)
      Chat.any_instance.should_receive(:finished?).and_return(true)

      get :responder, id: chat

      expect(response).to redirect_to(review_chat_path(chat))
    end
  end

  describe '#connection_timeout' do
    let!(:chat) { create(:chat) }

    before do
      login
    end

    it 'sets chat as finished' do
      post :connection_timeout, id: chat

      expect(chat.reload).to be_finished
    end

    it 'creates a system message telling no one picked up this chat' do
      post :connection_timeout, id: chat

      message = chat.reload.messages.last
      expect(message.status).to eq('system')
      expect(message.content).to eq('No one picked up.')
    end

    it 'triggers chat_status_event timeout type message' do
      Pusher["channel_chat_#{chat.id}"].should_receive(:trigger).with('chat_status_event',
        message: 'No one picked up.',
        html: anything,
        type: 'timeout')

      post :connection_timeout, id: chat
    end

    it 'returns :bad_request if chat already finished' do
      Chat.any_instance.should_receive(:finished?).and_return(true)

      post :connection_timeout, id: chat

      expect(response).to be_bad_request
    end
  end

  describe '#email' do
    let(:user) { login }
    let(:chat) { create(:chat) }

    it 'sends to email address fetched from user record if given email is masked' do
      ChatMailer.should_receive(:send_conversation).with(chat, user, user.email)
        .and_return(double.as_null_object)

      post :email, id: chat.id, review: { email: user.masked_email }
    end

    it 'sends to given email address if it is not a masked one' do
      ChatMailer.should_receive(:send_conversation).with(chat, user, 'foo@bar.com')
        .and_return(double.as_null_object)

      post :email, id: chat.id, review: { email: 'foo@bar.com' }
    end
  end

  describe '#review' do
    it 'responds success if chat is finished and current user participated in that chat' do
      user = login
      chat = stub_model(Chat, requester: user)
      Chat.stub_chain(:includes, :find).and_return(chat)
      chat.should_receive(:finished?).and_return(true)

      get :review, id: chat
      expect(response).to be_success
    end

    it 'redirects to root if chat is not finished' do
      user = login
      chat = stub_model(Chat, requester: user)
      Chat.stub_chain(:includes, :find).and_return(chat)
      chat.should_receive(:finished?).and_return(false)

      get :review, id: chat
      expect(response).to redirect_to(root_path)
    end

    it 'redirects to root if current user is not participated in that chat' do
      user = login
      chat = stub_model(Chat)
      Chat.stub_chain(:includes, :find).and_return(chat)
      chat.should_receive(:finished?).and_return(true)

      get :review, id: chat
      expect(response).to redirect_to(root_path)
    end
  end
end
