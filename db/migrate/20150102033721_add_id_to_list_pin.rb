class AddIdToListPin < ActiveRecord::Migration
  def change
    add_column :lists_pins, :id, :primary_key
  end
end
