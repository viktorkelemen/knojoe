class User < ActiveRecord::Base
  attr_accessible :name, :image, :email

  has_many :identities, dependent: :destroy
  has_many :messages, foreign_key: :author_id
  has_many :chats

  def self.create_with_omniauth(info)
    create(name: info['name'], image: info['image'], email: info['email'])
  end
end
