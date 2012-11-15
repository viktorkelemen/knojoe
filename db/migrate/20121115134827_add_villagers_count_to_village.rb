class AddVillagersCountToVillage < ActiveRecord::Migration
  def change
    add_column :villages, :villagers_count, :integer, default: 0
  end
end
