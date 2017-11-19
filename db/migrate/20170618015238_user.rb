class User < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :login, null: false, limit: 50
      t.string :password, null: false, limit: 50
      t.string :email, limit: 100
      t.timestamps
    end
  end
end
