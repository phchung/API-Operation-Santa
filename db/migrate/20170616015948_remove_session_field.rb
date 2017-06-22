class RemoveSessionField < ActiveRecord::Migration
  def change
    remove_column :sessions, :secret_token
    remove_column :sessions, :agent_token

    add_index :sessions, :user_id
  end
end
