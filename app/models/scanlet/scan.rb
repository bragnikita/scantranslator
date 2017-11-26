class Scanlet::Scan < ApplicationRecord
  self.table_name =  'scanlet_scans'
  mount_uploader :image, ScanUploader
end