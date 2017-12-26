class Common::ImageLink < ApplicationRecord
  self.table_name = "common_image_links"
  belongs_to :target, :class_name => "Common::Image"
  belongs_to :group, :class_name => "Common::Group", optional: true
end