class User < ActiveRecord::Base
  attr_accessible :name, :image, :email

  has_many :identities, dependent: :destroy
  has_many :messages, foreign_key: :author_id
  has_many :chats
  has_many :asked_questions, class_name: 'Chat', foreign_key: :requester_id,
    order: 'chats.created_at DESC'
  has_many :helped_questions, class_name: 'Chat', foreign_key: :responder_id,
    order: 'chats.created_at DESC' do
      def on_today
        where(created_at: (Date.today.beginning_of_day..Date.today.end_of_day))
      end
  end

  def self.create_with_omniauth(info)
    create(name: info['name'], image: info['image'], email: info['email'])
  end

  DAILY_PUSH_NOTIFICATION_LIMIT = 10

  def available_for_push_notification?
    helped_questions.on_today.count <= DAILY_PUSH_NOTIFICATION_LIMIT
  end
end
