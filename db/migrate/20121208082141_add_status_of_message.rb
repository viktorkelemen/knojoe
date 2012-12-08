class AddStatusOfMessage < ActiveRecord::Migration
  def change
    add_column :messages, :status, :string, default: 'user'
  end
end
