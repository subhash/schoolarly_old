class CreateSchoolarlyAdmins < ActiveRecord::Migration
  def self.up
    create_table :schoolarly_admins do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :schoolarly_admins
  end
end
