class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.integer :sender_id, :null => false
      t.integer :receiver_id,:null => false
      t.string :subject
      t.string :body
      t.datetime :time
      t.enum :status, :limit => ['read','unread','spam']
      
      t.timestamps
      
      t.foreign_key :sender_id,:users,:id
      t.integer :receiver_id, :users, :id
    end
  end
  
  def self.down
    drop_table :messages
  end
end
