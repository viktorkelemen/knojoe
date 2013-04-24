class Chat < ActiveRecord::Base
  attr_accessible :requester, :responder, :initial_message, :started_at, :finished_at
  attr_accessor :initial_message

  belongs_to :requester, foreign_key: :requester_id, class_name: 'User'
  belongs_to :responder, foreign_key: :responder_id, class_name: 'User'
  has_many :messages

  validates :requester, presence: true

  scope :recent, ->(limit = 5) { order('created_at DESC').limit(limit) }

  before_create :create_initial_message, if: 'initial_message'
  after_create :check_connection_timeout

  def started_offset(default = -1)
    if started_at
      (Time.now - started_at.to_i).to_i
    else
      default
    end
  end

  def finished?
    !!finished_at
  end

  def finish
    self.finished_at = Time.now
    save!
  end

  def started?
    !!started_at
  end

  def start
    self.started_at = Time.now
    save!
  end

  def assign_responder(user)
    self.responder = user
    save!
  end

  def check_connection_timeout
    # do not close it if there is a responder
    return if finished? || responder
    update_attributes!(finished_at: Time.now)
  end
  handle_asynchronously :check_connection_timeout, run_at: Proc.new { 3.minutes.from_now }

  def self.num_of_active_chats
    where(started_at: nil, finished_at: nil).count
  end

  private

  def create_initial_message
    messages.new(content: initial_message, author: requester)
  end
end
