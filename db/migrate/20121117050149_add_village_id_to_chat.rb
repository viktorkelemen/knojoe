class AddVillageIdToChat < ActiveRecord::Migration
  def change
    add_column :chats, :village_id, :integer
  end
end
