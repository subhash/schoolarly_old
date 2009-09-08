class CreateLeaveRequests < ActiveRecord::Migration
  def self.up
    create_table :leave_requests do |t|
      t.integer :parent_id, :null => false
      t.date :start_date
      t.date :end_date
      t.string :reason
      t.enum :status, :limit => ['requested', 'confirmed', 'rejected', 'pending']
      
      t.timestamps
      
      t.foreign_key :parent_id, :users,:id
    end
  end
  
  def self.down
    drop_table :leave_requests
  end
end
