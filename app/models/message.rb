class Message < ActiveRecord::Base
  attr_accessible :author, :content

  belongs_to :chat
  belongs_to :author, foreign_key: 'author_id', class_name: 'User'

  validates :author, presence: true
end
