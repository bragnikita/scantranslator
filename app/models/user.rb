class User < ApplicationRecord
  has_many :posts, class_name: Post.name, dependent: :restrict_with_error, inverse_of: :owner, foreign_key: 'owner_id'

  def self.create_default
    User.create(login: 'nikita', password: '123')
  end
end