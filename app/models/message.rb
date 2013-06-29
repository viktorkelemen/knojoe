class Message < ActiveRecord::Base
  attr_accessible :author, :content, :status

  belongs_to :chat
  belongs_to :author, foreign_key: 'author_id', class_name: 'User'
  has_one :like

  # validates :author, presence: true
  validate :chat_finished

  scope :recent, -> { reorder('messages.created_at DESC') }
  scope :user_messages, -> { where(status: 'user') }

  def chat_finished
    errors.add(:base, 'chat is finished') if chat.try(:finished?)
  end

  def liked?
    like.present?
  end
end
