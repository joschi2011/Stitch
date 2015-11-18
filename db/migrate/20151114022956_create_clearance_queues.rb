class CreateClearanceQueues < ActiveRecord::Migration
  def change
    create_table :clearance_queues do |t|
      t.integer :items
      t.timestamps null: false
    end
  end
end
