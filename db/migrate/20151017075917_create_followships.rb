class CreateFollowships < ActiveRecord::Migration
  def change
    create_table :followships do |t|
      t.integer :follower_id, :followee_id
      t.timestamps
    end
  end
end
