class Common::Group < ApplicationRecord
  self.table_name= "common_groups"
  belongs_to :parent, :class_name => "Common::Group"
  has_many :children, :class_name => "Common:Group", foreign_key: "parent_id"
end