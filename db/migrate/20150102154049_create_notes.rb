class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.text :title
      t.text :body
      t.integer :type

      t.timestamps null: false
    end
  end
end
