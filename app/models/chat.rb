class Chat < ActiveRecord::Base
  attr_accessible :requester, :responder, :initial_message, :started_at, :finished_at
  attr_accessor :initial_message

  belongs_to :requester, foreign_key: :requester_id, class_name: 'User'
  belongs_to :responder, foreign_key: :responder_id, class_name: 'User'
  has_many :messages

  validates :requester, presence: true

  before_create :create_initial_message, if: 'initial_message'

  private

  def create_initial_message
    messages.new(content: initial_message, author: requester)
  end
end
