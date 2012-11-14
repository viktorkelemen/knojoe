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

    describe 'guest' do
      let(:chat) { build(:chat, guest_id: user.id) }

      subject { chat.guest }

      it { should == user }
    end

    describe 'villager' do
      let(:chat) { build(:chat, villager_id: user.id) }

      subject { chat.villager }

      it { should == user }
    end
  end
end
