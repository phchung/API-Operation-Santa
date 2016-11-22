class AddingWistlist < ActiveRecord::Migration
  def change
      remove_column :families, :user_id, :integer
      add_column :families, :wish_list, :text
      drop_table :donor
  end
end
