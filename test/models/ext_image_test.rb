require 'test_helper'

class ExtImageTest < ActiveSupport::TestCase

  def setup
    FileUtils.remove_dir file_in ""
  end

  test 'create' do
    i = ExtImage.upload_from_disk Rails.root.join('test', 'fixtures', 'files', 'series_schema.png')
    assert i.valid?
    assert File::exists? file_in "default/#{i.id}/series_schema.png"
    assert File::exists? file_in "default/#{i.id}/thumb_series_schema.png"
  end

  private

  def file_in(path_fom_root)
    Rails.root.join('test', 'tmp', 'external', 'images', path_fom_root )
  end

  def prepare_file
    ExtImage.new_from_disk Rails.root.join('test', 'fixtures', 'files', 'series_schema.png')
  end

end