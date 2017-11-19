class CreateExtImage < ActiveRecord::Migration[5.1]
  def up
    create_table :ext_images do |t|
      t.string :image
      t.timestamps
    end
  end

  def down
    drop_table :ext_images
  end
end
