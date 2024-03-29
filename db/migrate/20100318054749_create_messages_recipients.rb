class CreateMessagesRecipients < ActiveRecord::Migration
  def self.up
    create_table :messages_recipients, :id => false do |t|
      t.column :message_id, :integer, :null => false
      t.column :recipient_id, :integer, :null => false
      
      t.foreign_key :message_id, :messages, :id
      t.foreign_key :recipient_id, :users, :id
    end
    #i use foreign keys but its a custom method, so i'm leaving it up to you want them.
  end

  def self.down
    drop_table :messages_recipients
  end
end
