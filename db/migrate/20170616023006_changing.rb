class Changing < ActiveRecord::Migration
  def change
    remove_column :sessions, :expiration
    add_column :sessions, :expiration, :date
  end
end
