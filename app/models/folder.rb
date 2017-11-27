class Folder < ApplicationRecord
  has_many :images, class_name: ExtImage.name
  has_many :children, class_name: Folder.name, dependent: :restrict_with_error, foreign_key: 'parent_id'
  belongs_to :parent, class_name: Folder.name, required: false
  validates :name, presence: true, uniqueness: true, format: {with: /\A[\w]+[\-\w\/]*[\w]?\z/i}
  before_validation :fix_name
  before_save :full_path, if: :will_save_change_to_name?
  before_update :full_path, if: :will_save_change_to_name?

  after_save :update_child_paths, if: :saved_change_to_path?
  after_update :update_child_paths, if: :saved_change_to_path?

  def self.trash
    Folder.find_by_path('/trash')
  end

  protected
  def fix_name
    folder = self.name

    folder = folder.strip
    folder.slice!(0) if folder[0] == '/'
    folder.chop! if folder[folder.length-1] == '/'

    self.name = folder
  end

  def full_path
    folder = self.name
    if self.parent.nil?
      self.path = '/' + folder
    else
      self.path = self.parent.path + "/" + folder
    end
  end

  def update_child_paths
    self.reload
    self.children.each do |child|
      child.full_path
      child.save
    end
  end

end