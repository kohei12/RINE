class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.references :friendship, null: false

      t.timestamps null: false
    end

    add_index :rooms, :friendship_id, unique: true
  end
end
