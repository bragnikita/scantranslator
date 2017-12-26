class Scanlet::Project < ApplicationRecord
  self.table_name =  'scanlet_projects'
  validates :name, presence: true, uniqueness: true
  has_many :groups, :class_name => 'Group', dependent: :destroy, foreign_key: 'project_id'
  belongs_to :cover, :class_name => 'Common::ImageLink', optional: true

  TEST_IMAGE = Rails.root.join('test', 'fixtures', 'files', 'scan.png')

  def self.create_test_struct(project_name)

    ActiveRecord::Base.transaction do
      project = Scanlet::Project.create({name: project_name})
      project.save!
      p project
      group = Group.new({name: project_name + '_group1', project: project})
      group.save
      (1..3).each do |index|
        File.open(TEST_IMAGE) do |f|
          scan = Scanlet::Scan.create({image: f})
          group.translations.build({
                                             scan: scan,
                                             index: index
                                         })
          group.save
        end
      end
    end
  end

  def self.clear_all
    Scanlet::Project.destroy_all
  end
end