class AddIndexToApplicationsTable < ActiveRecord::Migration[5.2]
  def change
    add_index :applications, :token, unique: true
  end
end
