class Chat < ActiveRecord::Base
  attr_accessible :requester, :responder, :initial_message, :started_at, :finished_at
  attr_accessor :initial_message

  belongs_to :requester, foreign_key: :requester_id, class_name: 'User'
  belongs_to :responder, foreign_key: :responder_id, class_name: 'User'
  has_many :messages

  validates :requester, presence: true

  before_create :create_initial_message, if: 'initial_message'

  def started_offset(default=-1)
    if started_at
      (Time.now - started_at.to_i).to_i
    else
      default
    end
  end

  def finished?
    !!finished_at
  end

  def started?
    !!started_at
  end

  private

  def create_initial_message
    messages.new(content: initial_message, author: requester)
  end
end
