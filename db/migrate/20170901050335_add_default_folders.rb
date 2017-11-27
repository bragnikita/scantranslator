class AddDefaultFolders < ActiveRecord::Migration[5.1]
  def change
    Folder.create(name: 'trash', parent: nil)
    Folder.create(name: 'common', parent: nil)
  end
end
