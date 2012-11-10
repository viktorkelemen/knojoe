class Chat < ActiveRecord::Base
  attr_accessible :guest_id, :villager_id

  has_many :messages
end
