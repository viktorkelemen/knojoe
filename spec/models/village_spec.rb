require 'spec_helper'

describe Village do
  describe 'associations' do
    describe '.villager' do
      let!(:user) { create(:user) }
      let!(:village) { create(:village) }

      before { create(:participation, user: user, village: village) }

      subject { village.villagers }

      it { should == [user] }
    end
  end

  describe '.villagers_count counter cache' do
    let!(:village) { create(:village) }
    let(:user) { create(:user) }

    it 'should update counter cache' do
      expect { village.villagers << user }.
        to change { village.villagers_count }.from(0).to(1)

      expect { village.villagers.delete(user) }.
        to change { village.villagers_count }.from(1).to(0)
    end
  end
end
