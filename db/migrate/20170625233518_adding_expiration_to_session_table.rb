class AddingExpirationToSessionTable < ActiveRecord::Migration
  def change
    add_column :sessions, :expiration, :date
  end
end
