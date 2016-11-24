class Session < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :session_token, null: false
      t.string :secret_token, null: false
      t.string :agent_token, null: false
      t.integer :user_id, null: false
      t.date :expiration, null: false

      t.timestamps null: false
    end
  end
end
