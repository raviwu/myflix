class DropReferorEmailInUsers < ActiveRecord::Migration
  def change
    remove_column :users, :referor_email
  end
end
