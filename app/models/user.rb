class User < ActiveRecord::Base
  attr_accessible :name, :image

  has_many :identities, dependent: :destroy
  has_many :messages, foreign_key: :author_id
  has_many :chats
  has_many :participations, dependent: :destroy
  has_many :villages, through: :participations

  def self.create_with_omniauth(info)
    create(name: info['name'], image: info['image'])
  end

  def joined?(village)
    villages.include?(village)
  end
end
