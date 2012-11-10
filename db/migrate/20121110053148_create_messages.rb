class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :chat
      t.integer :author_id
      t.text :content

      t.timestamps
    end
    add_index :messages, :chat_id
  end
end
