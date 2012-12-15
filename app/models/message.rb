class Message < ActiveRecord::Base
  attr_accessible :author, :content, :status

  belongs_to :chat
  belongs_to :author, foreign_key: 'author_id', class_name: 'User'
  has_one :like

  # validates :author, presence: true
  validate :chat_finished

  def chat_finished
    errors.add(:base, 'chat is finished') if chat.finished_at
  end

  def liked?
    like.present?
  end
end
