class AddCommonImagesTable < ActiveRecord::Migration[5.1]
  def up
    create_table 'common_images' do |t|
      t.string :file
      t.integer :storage, default: 0
      t.boolean :is_using, default: false
      t.timestamps
    end
  end

  def down
    drop_table 'common_images'
  end
end
