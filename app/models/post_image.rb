
require 'carrierwave/orm/activerecord'

class PostImage < ApplicationRecord

  mount_uploader :image, PostImageUploader

  belongs_to :user, class_name: User.name

end