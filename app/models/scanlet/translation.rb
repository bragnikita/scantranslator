class Scanlet::Translation < ApplicationRecord
  self.table_name = 'scanlet_translations'
  belongs_to :group, :class_name => 'Group', required: false, foreign_key: 'group_id'
  belongs_to :scan, :class_name => 'Scanlet::Scan', required: true, foreign_key: 'scan_id', dependent: :destroy
end