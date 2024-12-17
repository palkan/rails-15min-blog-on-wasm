class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.date :date
      t.text :body

      t.timestamps
    end
  end
end
