class Scanlet::Project < ApplicationRecord
  validates :name, presence: true
  has_many :scantrans_groups, :class_name => 'Scanlet::ScantransGroup', dependent: :restrict_with_error
end