class AddImageToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :image, :text
  end
end
