class CommonImage < ActiveRecord::Base
  mount_uploader :file, CommonImageUploader
end