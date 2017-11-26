class AddScanletMainTables < ActiveRecord::Migration[5.1]

  def up
    down

    create_table 'scanlet_projects' do |t|
      t.string 'name', null: false
      t.text 'description'
      t.string 'cover'
      t.timestamps
    end

    create_table 'scanlet_groups' do |t|
      t.references :project, null: false
      t.string 'name', null: false
      t.integer 'index'
      t.timestamps
    end


    create_table 'scanlet_scans' do |t|
      t.string 'image', null: false
      t.string 'size'
    end

    create_table 'scanlet_translations' do |t|
      t.text 'translation'
      t.integer 'index'
      t.timestamps
    end
    add_reference :scanlet_translations, :scan, references: :scanlet_scans, foreign_key: {to_table: :scanlet_scans, on_delete: :restrict}
    add_reference :scanlet_translations, :group, references: :scanlet_groups, foreign_key: {to_table: :scanlet_groups, on_delete: :restrict}

  end

  def down
    drop_table :scanlet_translations if table_exists? :scanlet_translations
    drop_table :scanlet_scans if table_exists? :scanlet_scans
    drop_table :scanlet_groups if table_exists? :scanlet_groups
    drop_table :scanlet_projects if table_exists? :scanlet_projects
  end
end
