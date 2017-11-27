unless Folder.find_by_path('/trash').present?
  Folder.create(name: 'trash', parent: nil)
end
unless Folder.find_by_path('/common').present?
  Folder.create(name: 'common', parent: nil)
end