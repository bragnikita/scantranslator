class ExtImage < ApplicationRecord
  mount_uploader :image, ExtImageUploaderS3
  validates :image, presence: true
  belongs_to :folder, class_name: Folder.name, required: false

  def self.new_from_disk(path)
    image = ExtImage.new
    File.open path do |f|
      image.image = f
    end
    image
  end

  def self.upload_from_disk(path)
    image = ExtImage.new
    File.open path do |f|
      image.image = f
    end
    image.save!
    image
  end

  def preview
    return image.thumb if image.thumb.present?
    image
  end

end