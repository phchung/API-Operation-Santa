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


# session_token = BCrypt(current_time + email + SecureRandom)

# save this to DB
# token = session_token + HTTP_USER_AGENT + HTTP_X_FORWARDED_FOR
