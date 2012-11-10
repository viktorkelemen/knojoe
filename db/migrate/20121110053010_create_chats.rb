class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|
      t.integer :villager_id
      t.integer :guest_id

      t.timestamps
    end
  end
end
