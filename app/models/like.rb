class Like < ActiveRecord::Base
  attr_accessible :message, :user

  belongs_to :message
  belongs_to :user

  after_create :update_likes_count

  private

  def update_likes_count
    message.author.increment!(:received_likes_count)
  end
end
