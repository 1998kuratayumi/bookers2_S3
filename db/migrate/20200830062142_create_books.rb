class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.float :rate
      t.string :title
      t.text :body
      t.string :category
      t.integer :user_id
      t.timestamps
    end
  end
end
