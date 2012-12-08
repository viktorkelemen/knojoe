require 'spec_helper'

describe Chat do
  describe 'callbacks' do
    describe '.create_initial_message' do
      context 'when initial message is provided' do
        let!(:chat) { create(:chat, initial_message: 'hello') }

        it 'should create a message with its content' do
          Message.should have(1).records
          Message.first.content.should == 'hello'
        end

        it 'should have same author associated as its chat' do
          Message.first.author.should == chat.guest
        end
      end

      context 'when initial message is not provided' do
        before { create(:chat) }

        it 'should not create a message' do
          Message.should have(0).records
        end
      end
    end
  end

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
end
