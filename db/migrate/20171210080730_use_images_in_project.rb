class UseImagesInProject < ActiveRecord::Migration[5.1]
  def up

    unless table_exists? :common_groups

      create_table :common_groups do |t|
        t.string :name
      end
      add_belongs_to :common_groups, :parent, foreign_key: {to_table: :common_groups}

    end

    unless table_exists? :common_image_links

      create_table :common_image_links do |t|
      end


      add_reference :common_image_links, :target, foreign_key: {to_table: :common_images}, null: false
      add_reference :common_image_links, :group, foreign_key: {to_table: :common_groups}, null: true

    end

    unless column_exists? :common_image_links, :cover


      change_table :scanlet_projects do |t|
        t.remove :cover if t.column_exists? :cover
      end
      add_reference :scanlet_projects, :cover, foreign_key: {to_table: :common_image_links}

    end
  end

  def down
    remove_reference :scanlet_projects, :cover, foreign_key: {to_table: :common_image_links}
    drop_table :common_image_links, if_exists: true, force: :cascade
    drop_table :common_groups, if_exists: true, force: :cascade
  end
end
