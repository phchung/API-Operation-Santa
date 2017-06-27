class AddingIndexToSession < ActiveRecord::Migration
  def change
    add_index :sessions, :user_id
    add_index :sessions, :session_token
  end
end
