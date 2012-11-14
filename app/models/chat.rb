class Chat < ActiveRecord::Base
  attr_accessible :guest_id, :villager_id, :initial_message

  attr_accessor :initial_message

  has_many :messages
end
