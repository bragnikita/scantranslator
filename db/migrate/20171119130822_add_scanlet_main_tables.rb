class AddScanletMainTables < ActiveRecord::Migration[5.1]

  def up
    down

    create_table 'projects' do |t|
      t.string 'name', null: false
      t.text 'description'
      t.string 'cover'
      t.timestamps
    end

    create_table 'scantrans_groups' do |t|
      t.references :project, null: false
      t.string 'name', null: false
      t.integer 'index'
      t.timestamps
    end


    create_table 'scan's do |t|
      t.string 'image', null: false
      t.string 'size'
    end

    create_table 'scan_translations' do |t|
      t.text 'translation'
      t.integer 'index'
      t.timestamps
    end
    add_reference :scan_translation, :scan, references: :scan, foreign_key: {to_table: :scan, on_delete: :restrict}
    add_reference :scan_translation, :group, references: :scantrans_group, foreign_key: {to_table: :scantrans_group, on_delete: :restrict}

  end

  def down
    drop_table :scan_translations if table_exists? :scan_translations
    drop_table :scans if table_exists? :scans
    drop_table :scantrans_groups if table_exists? :scantrans_groups
    drop_table :projects if table_exists? :projects
  end
end
