class Village < ActiveRecord::Base
  attr_accessible :name

  has_many :participations
  has_many :villagers, through: :participations, source: :user

  validates :name, presence: true
end
