class CreatePostImages < ActiveRecord::Migration[5.1]
  def change
    create_table :post_images do |t|
      t.string :image
      t.references :user, foreign_key: true, null: true
      t.timestamps
    end
  end
end
