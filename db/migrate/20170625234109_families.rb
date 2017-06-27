class Families < ActiveRecord::Migration
  def change
    create_table :families do |t|
      t.integer :user_id, null: false

      t.integer :family_size, null: false
      t.text :family_photo
      t.text :family_story
      t.text :wish_list

      t.timestamps
    end
  end
end
