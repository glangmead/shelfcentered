class AddListPinIdToNote < ActiveRecord::Migration
  def change
    add_column :notes, :list_pin_id, :integer
  end
end
