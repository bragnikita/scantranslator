class Common::Image < ApplicationRecord
  self.table_name = "common_images"
  mount_uploader :file, CommonImageUploader
end