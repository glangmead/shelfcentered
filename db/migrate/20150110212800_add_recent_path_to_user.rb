class AddRecentPathToUser < ActiveRecord::Migration
  def change
    add_column :users, :recent_path1, :string
    add_column :users, :recent_path2, :string
    add_column :users, :recent_path3, :string
    add_column :users, :recent_path4, :string
    add_column :users, :recent_path5, :string
    add_column :users, :recent_path6, :string
    add_column :users, :recent_path7, :string
    add_column :users, :recent_path8, :string
    add_column :users, :recent_path9, :string
  end
end
