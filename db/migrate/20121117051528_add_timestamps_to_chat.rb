class AddTimestampsToChat < ActiveRecord::Migration
  def change
    add_column :chats, :started_at, :datetime
    add_column :chats, :finished_at, :datetime
  end
end
