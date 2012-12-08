class AddReceivedLikesCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :received_likes_count, :integer, default: 0
  end
end
