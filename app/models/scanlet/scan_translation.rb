class Scanlet::ScanTranslation < ApplicationRecord
  has_one :group, :class_name => 'Scanlet::ScanTranslation', required: false
  has_one :scan, :class_name => 'Scanlet::Scan', required: true
end