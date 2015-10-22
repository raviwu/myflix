class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :user_id
      t.string :recipient_fullname
      t.string :recipient_email
      t.text :message
      t.string :token
      t.timestamps
    end
  end
end
