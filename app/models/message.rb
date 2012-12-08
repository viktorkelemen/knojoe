class Message < ActiveRecord::Base
  attr_accessible :author, :content, :status

  belongs_to :chat
  belongs_to :author, foreign_key: 'author_id', class_name: 'User'
  has_one :like

  # validates :author, presence: true

  def liked?
    like.present?
  end
end
