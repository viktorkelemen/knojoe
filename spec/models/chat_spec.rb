require 'spec_helper'

describe Chat do
  describe 'callbacks' do
    describe 'create_initial_message' do
      context 'when initial message is provided' do
        before { create(:chat, initial_message: 'hello') }

        it 'should create a message with its content' do
          Message.should have(1).records
          Message.first.content.should == 'hello'
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
end
