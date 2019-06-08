class AddRetinaDimensionsToPins < ActiveRecord::Migration
  def change
    add_column :pins, :retina_dimensions, :text
  end
end
