class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.string :body
      t.integer :number
      t.belongs_to :chat, foreign_key: true
      t.index([:body, :chat_id])
      t.timestamps
    end
  end
end
