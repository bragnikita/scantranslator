class Scanlet::Group < ApplicationRecord
  self.table_name =  'scanlet_groups'
  validates :name, presence: true
  belongs_to :project, :class_name => 'Scanlet::Project', foreign_key: "project_id"
  has_many :translations, :class_name => 'Translation', dependent: :destroy, foreign_key: "group_id"
end