class Village < ActiveRecord::Base
  attr_accessible :name

  has_many :participations, dependent: :destroy
  has_many :villagers, through: :participations, source: :user
  has_many :chats

  validates :name, presence: true
end
