class RemoveUserId < ActiveRecord::Migration
  def change
    remove_column :user, :user_id, :integer
  end
end
