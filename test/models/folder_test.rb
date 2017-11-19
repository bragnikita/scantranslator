require 'test_helper'

class FolderTest < ActiveSupport::TestCase


  test 'create new root folder' do
    f = Folder.create(name: 'folder1', parent: nil)
    assert f.errors.blank?
    assert f.name = 'folder1'
    assert f.path = '/folder1'
  end

  test 'create nested folder' do
    f = Folder.create(name: '1', parent: nil)
    f2 = Folder.create(name: '2', parent: f)
    assert f2.errors.blank?, "not created, #{f2.errors}"
    assert f2.path = '/1/2', 'path is wrong'
    f.reload
    assert_not f.children.empty?
    assert f2.parent.present?
  end

  test 'add_file' do
    f = Folder.new(name: '1', parent: nil)
    image = prepare_file
    f.images << image
    assert f.save
    assert f.valid?
    assert_not f.images.empty?

    image = image.reload
    assert image.folder == f
    assert_includes f.images, image
  end

  test 'Update name' do
    prepare
    @child.update(name: 'new_child')
    assert_equal 'new_child', @child.name
    assert_equal '/parent/new_child', @child.path
  end

  test 'Rename parent folder' do
    prepare
    @child2 = Folder.create(name: 'child2', parent: @child)
    @parent.update(name: 'new_parent')
    @child.reload
    @child2.reload
    assert_equal '/new_parent/child', @child.path
    assert_equal '/new_parent/child/child2', @child2.path
  end

  private

  def prepare
    @parent = Folder.create(name: 'parent')
    @child = Folder.create(name: 'child', parent: @parent)
    @parent.reload
  end


  def prepare_file
    ExtImage.new_from_disk Rails.root.join('test', 'fixtures', 'files', 'series_schema.png')
  end
end
