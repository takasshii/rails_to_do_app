class AddColumnsToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :post_importance, :integer
    add_column :posts, :post_deadline, :datetime
  end
end
