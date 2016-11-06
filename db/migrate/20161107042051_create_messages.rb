class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :room
      t.references :user
      t.text :text, null: false

      t.timestamps null: false
    end
  end
end
