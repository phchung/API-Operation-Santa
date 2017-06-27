class Relationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :donor_id, null: false
      t.integer :family_id, null: false

      t.timestamps
    end
  end
end
