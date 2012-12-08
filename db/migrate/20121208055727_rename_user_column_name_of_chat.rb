class RenameUserColumnNameOfChat < ActiveRecord::Migration
  def up
    rename_column :chats, :guest_id, :requester_id
    rename_column :chats, :villager_id, :responder_id
  end

  def down
    rename_column :chats, :requester_id, :guest_id
    rename_column :chats, :responder_id, :villager_id
  end
end
