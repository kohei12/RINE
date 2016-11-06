class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.references :friendship, null: false
      t.references :user
      t.references :friend

      t.timestamps null: false
    end
  end
end
