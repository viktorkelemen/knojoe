require 'spec_helper'

describe VillagesController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      get 'show'
      response.should be_success
    end
  end

  describe "GET 'create'" do
    it "returns http success" do
      get 'create'
      response.should be_success
    end
  end

  describe "POST 'join'" do
    let(:user) { create(:user) }
    let(:village) { create(:village) }

    before do
      session[:user_id] = user.id
      post 'join', id: village.id
    end

    it 'should join the village' do
      village.villagers.should include(user)
    end

    it 'should update the counter' do
      village.reload.villagers_count.should == 1
    end
  end

  describe "DELETE 'join'" do
    let(:user) { create(:user) }
    let(:village) { create(:village) }

    before do
      session[:user_id] = user.id
      delete 'quit', id: village.id
    end

    it 'should quit the village' do
      village.villagers.should_not include(user)
    end

    it 'should update the counter' do
      village.reload.villagers_count.should == 0
    end
  end
end
