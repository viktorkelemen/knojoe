class Chat < ActiveRecord::Base
  attr_accessible :guest_id, :villager_id, :initial_message

  attr_accessor :initial_message

  has_many :messages

  before_create :create_initial_message, if: 'initial_message'

  private

  def create_initial_message
    messages.new(content: initial_message)
  end
end
