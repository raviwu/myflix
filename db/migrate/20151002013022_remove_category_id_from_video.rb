class RemoveCategoryIdFromVideo < ActiveRecord::Migration
  def change
    remove_column :videos, :category_id
  end
end
