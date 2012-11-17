class Like < ActiveRecord::Base
  attr_accessible :message, :user

  belongs_to :message
  belongs_to :user
end
