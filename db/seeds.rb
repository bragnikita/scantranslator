# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

u = User.create_default
Post.create([{
                 title: 'Post 1',
                 owner: u,
                 status: Post.statuses[:draft]
             }, {
                 title: 'Post 2',
                 owner: u,
                 status: Post.statuses[:published]
             }])
i = PostImage.new
i.user = u
File.open 'db/seed/photo.png' do |f|
  i.image = f
end
i.save