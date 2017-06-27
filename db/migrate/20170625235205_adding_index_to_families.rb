class AddingIndexToFamilies < ActiveRecord::Migration
  def change
    add_index :relationships, :donor_id
    add_index :relationships, :family_id
  end
end
