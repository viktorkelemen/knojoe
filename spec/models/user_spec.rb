require 'spec_helper'

describe User do
  describe '.joined?' do
    let(:user) { create(:user) }
    let(:village) { create(:village) }

    subject { user.joined?(village) }

    context 'when user joined village' do
      before { village.villagers << user }

      it { should be_true }
    end

    context 'when user not joined village' do
      it { should be_false }
    end
  end
end
