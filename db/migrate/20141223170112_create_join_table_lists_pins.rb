class CreateJoinTableListsPins < ActiveRecord::Migration
  def change
    create_join_table :lists, :pins do |t|
      # t.index [:list_id, :pin_id]
      # t.index [:pin_id, :list_id]
    end
  end
end
