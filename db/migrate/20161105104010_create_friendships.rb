class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships do |t|
      t.references :user
      t.references :friend
      t.integer :status
      t.datetime :accepted_at

      t.timestamps null: false
    end

    add_index :friendships, [:user_id, :friend_id], unique: true
  end
end
