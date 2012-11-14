class Chat < ActiveRecord::Base
  attr_accessible :guest, :villager, :initial_message
  attr_accessor :initial_message

  belongs_to :guest, foreign_key: :guest_id, class_name: 'User'
  belongs_to :villager, foreign_key: :villager_id, class_name: 'User'
  has_many :messages

  validates :guest, presence: true

  before_create :create_initial_message, if: 'initial_message'

  private

  def create_initial_message
    messages.new(content: initial_message, author: guest)
  end
end
