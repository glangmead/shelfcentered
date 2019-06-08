class AddTimestampsToListsPins < ActiveRecord::Migration
  def change
    add_column :lists_pins, :created_at, :datetime
    add_column :lists_pins, :updated_at, :datetime
  end
end
