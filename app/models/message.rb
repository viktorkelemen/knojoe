class Message < ActiveRecord::Base
  belongs_to :chat
  belongs_to :author, foreign_key: 'author_id', class_name: 'User'
  attr_accessible :author_id, :content
end
