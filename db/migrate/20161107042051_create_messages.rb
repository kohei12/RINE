class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :user, null: false
      t.references :room, null: false
      t.text :text, null: false

      t.timestamps null: false
    end
  end
end
