class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.timestamp :publish_date
      t.integer :status, default: Post.statuses[:draft]
      t.text :content
      t.string :timestamps
    end
    add_reference :posts, :owner, references: :users, foreign_key: {to_table: :users, on_delete: :restrict}
  end
end
