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
end
