class AddScanletMainTables < ActiveRecord::Migration[5.1]

  def up
    down

    create_table 'project' do |t|
      t.string 'name', null: false
      t.text 'description'
      t.string 'cover'
      t.timestamps
    end

    create_table 'scantrans_group' do |t|
      t.references :project, null: false
      t.string 'name', null: false
      t.integer 'index'
      t.timestamps
    end


    create_table 'scan' do |t|
      t.string 'image', null: false
      t.string 'size'
    end

    create_table 'scan_translation' do |t|
      t.text 'translation'
      t.integer 'index'
      t.timestamps
    end
    add_reference :scan_translation, :scan, references: :scan, foreign_key: {to_table: :scan, on_delete: :restrict}
    add_reference :scan_translation, :group, references: :scantrans_group, foreign_key: {to_table: :scantrans_group, on_delete: :restrict}

  end

  def down
    drop_table :scan_translation if table_exists? :scan_translation
    drop_table :scan if table_exists? :scan
    drop_table :scantrans_group if table_exists? :scantrans_group
    drop_table :project if table_exists? :project
  end
end
