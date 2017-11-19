class Post < ApplicationRecord
  acts_as_taggable
  belongs_to :owner, class_name: User.name, inverse_of: :posts

  enum status: [
      :draft, :published, :hidden, :postponed
  ]
end