class ScantransGroup < ApplicationRecord
  validates :name, presence: true
  has_one :project, :class_name => 'Scanlet::Project'
  has_many :scan_translations, :class_name => 'Scanlet::ScanTranslation', dependent: :restrict_with_error
end