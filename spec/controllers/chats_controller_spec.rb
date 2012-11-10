require 'spec_helper'

describe ChatsController do

  describe "GET 'villager'" do
    it "returns http success" do
      get 'villager'
      response.should be_success
    end
  end

  describe "GET 'guest'" do
    it "returns http success" do
      get 'guest'
      response.should be_success
    end
  end

end
