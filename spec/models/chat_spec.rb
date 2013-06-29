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

  describe '#last_sentence_from_each_side' do
    it 'grabs last sentence from requester and responder' do
      requester = create(:requester)
      responder = create(:responder)
      chat = create(:chat, requester: requester, responder: responder)

      message_1 = create(:message, author: requester, chat: chat)
      system_message_1 = create(:system_message, chat: chat)
      message_2 = create(:message, author: responder, chat: chat)
      message_3 = create(:message, author: requester, chat: chat)

      expect(chat.last_sentence_from_each_side).to eq([message_3.content, message_2.content])
    end
  end
end
