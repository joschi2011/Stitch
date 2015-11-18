class FixColumnName < ActiveRecord::Migration
  def change
    rename_column :clearance_queues, :items, :scanned_item
  end
end
