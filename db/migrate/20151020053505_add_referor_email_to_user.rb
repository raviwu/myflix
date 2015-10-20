class AddReferorEmailToUser < ActiveRecord::Migration
  def change
    add_column :users, :referor_email, :string
  end
end
