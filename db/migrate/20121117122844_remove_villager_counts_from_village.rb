class RemoveVillagerCountsFromVillage < ActiveRecord::Migration
  def up
    remove_column :villages, :villager_counts
  end

  def down
    add_column :villages, :villager_counts, :integer
  end
end
