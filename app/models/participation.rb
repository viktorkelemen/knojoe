class Participation < ActiveRecord::Base
  belongs_to :village, counter_cache: :villagers_count
  belongs_to :user
end
