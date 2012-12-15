class User < ActiveRecord::Base
  attr_accessible :name, :image, :email

  has_many :identities, dependent: :destroy
  has_many :messages, foreign_key: :author_id
  has_many :chats
  has_many :asked_questions, class_name: 'Chat', foreign_key: :requester_id
  has_many :helped_questions, class_name: 'Chat', foreign_key: :responder_id

  def self.create_with_omniauth(info)
    create(name: info['name'], image: info['image'], email: info['email'])
  end

end
