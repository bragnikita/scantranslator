class CreateFolder < ActiveRecord::Migration[5.1]
  def up
    create_table :folders do |t|
      t.string :name, null: false
      t.text :description_text
      t.string :path, null: false
    end
    add_belongs_to :folders, :parent, references: :folders,
                   index: true, null: true, foreign_key: {to_table: :folders}
    add_belongs_to :ext_images, :folder, references: :folders, foreign_key: true,
                   index: true, null: true
  end

  def down
    remove_reference :ext_images, :folder, column: :folder_id, foreign_key: true, index: true
    remove_foreign_key :folders, column: :parent_id
    remove_index :folders, column: :parent_id if index_exists? :folders, :parent_id
    drop_table :folders, if_exists: true
  end
end
