class Relationship < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :donor_id, null: false
      t.integer :family_id, null: false

      t.timestamps null: false
    end

    add_index :relationships, :donor_id
    add_index :relationships, :family_id
  end
end
