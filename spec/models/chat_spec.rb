require 'spec_helper'

describe Chat do
  describe 'assosications' do
    let(:user) { create(:user) }

    describe 'requester' do
      let(:chat) { build(:chat, requester_id: user.id) }

      subject { chat.requester }

      it { should == user }
    end

    describe 'responder' do
      let(:chat) { build(:chat, responder_id: user.id) }

      subject { chat.responder }

      it { should == user }
    end
  end

  describe 'last message helpers' do
    let(:requester) { create(:requester) }
    let(:responder) { create(:responder) }
    let(:chat) { create(:chat, requester: requester, responder: responder) }

    describe 'requester' do
      it 'grabs the last message' do
        message_1 = create(:message, author: requester, chat: chat)
        system_message_1 = create(:system_message, chat: chat)
        message_2 = create(:message, author: responder, chat: chat)
        message_3 = create(:message, author: requester, chat: chat)

        expect(chat.last_message_from_requester).to eq(message_3.content)
      end

      it 'returns nil if there is no message besides the initial question' do
        expect(chat.last_message_from_requester).to be_nil
      end
    end

    describe 'responder' do
      it 'grabs the last message' do
        message_1 = create(:message, author: requester, chat: chat)
        system_message_1 = create(:system_message, chat: chat)
        message_2 = create(:message, author: responder, chat: chat)
        message_3 = create(:message, author: requester, chat: chat)

        expect(chat.last_message_from_responder).to eq(message_2.content)
      end

      it 'returns nil if there is no message besides the initial question' do
        expect(chat.last_message_from_responder).to be_nil
      end
    end
  end

end
