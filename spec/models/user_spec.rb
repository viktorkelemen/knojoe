require 'spec_helper'

describe User do
  describe '#masked_email' do
    it 'masks 3 characters before "@" mark' do
      user = User.new(email: 'abc123@foo.com')
      expect(user.masked_email).to eq('abc***@foo.com')
    end
  end
end
