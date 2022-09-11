class CreateChatsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :chats do |t|
      t.integer :chat_number
      t.integer :messages_count
      t.belongs_to :application, foreign_key: true
      t.index([:chat_number, :application_id], unique: true)
    end
  end
end
