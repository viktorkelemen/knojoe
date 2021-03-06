class Chat < ActiveRecord::Base
  attr_accessible :requester, :responder, :started_at, :finished_at, :messages_attributes

  belongs_to :requester, foreign_key: :requester_id, class_name: 'User'
  belongs_to :responder, foreign_key: :responder_id, class_name: 'User'
  has_many :messages, order: 'messages.created_at ASC'
  has_one :first_message, class_name: 'Message', order: 'messages.created_at ASC'

  accepts_nested_attributes_for :messages, reject_if: :all_blank

  validates :requester, :messages, presence: true

  scope :recent, ->(limit = 5) { order('created_at DESC').limit(limit) }

  after_create :check_connection_timeout, :check_chat_timeout

  def self.num_of_active_chats
    where(started_at: nil, finished_at: nil).count
  end

  def started_offset(default = -1)
    if started_at
      (Time.zone.now - started_at.to_i).to_i
    else
      default
    end
  end

  def finished?
    !!finished_at
  end

  def finish
    self.finished_at = Time.zone.now
    save!
  end

  def started?
    !!started_at
  end

  def start
    self.started_at = Time.zone.now
    save!
  end

  def connected_time
    return unless finished_at && started_at

    connected = finished_at - started_at
    format = connected > 60 ? '%Mm %Ss' : '%Ss'
    Time.zone.at(connected).strftime(format)
  end

  def assign_responder(user)
    self.responder = user
    save!
  end

  def last_message_from_requester
    recent_messages = messages.user_messages.where(author_id: requester_id).recent
    #the first message is the question we should not include that
    recent_messages.first.try(:content) unless recent_messages.length == 1
  end

  def last_message_from_responder
    messages.user_messages.where(author_id: responder_id).recent.first.try(:content)
  end

  private

  def check_connection_timeout
    return if responder

    finish
    # use "worker_" prefix to indicate this event is supposed to be sent by a
    # "worker" process, not from normal user interactions.
    Pusher["presence-home"].trigger('worker_connection_timeout_event', chat_id: id)
  end
  handle_asynchronously :check_connection_timeout, run_at: Proc.new { 1.minute.from_now }

  def check_chat_timeout
    # do not close it if there is a responder
    return if finished? || responder
    finish
  end
  handle_asynchronously :check_chat_timeout, run_at: Proc.new { 3.minutes.from_now }
end
