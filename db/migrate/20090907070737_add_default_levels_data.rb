class AddDefaultLevelsData < ActiveRecord::Migration
  
  def self.up
    Level.create(:name => 'Pre-school', :description => 'Pre-school')
    Level.create(:name => ' L.K.G', :description => ' L.K.G')
    Level.create(:name => 'U.K.G', :description => 'U.K.G')
    Level.create(:name => 'Mont1', :description => 'Mont1')
    Level.create(:name => 'Mont2', :description => 'Mont2')
    Level.create(:name => 'Mont3', :description => 'Mont3')
    Level.create(:name => '1', :description => '1')
    Level.create(:name => '2', :description => '2')
    Level.create(:name => '3', :description => '3')
    Level.create(:name => '4', :description => '4')
    Level.create(:name => '5', :description => '5')
    Level.create(:name => '6', :description => '6')
    Level.create(:name => '7', :description => '7')
    Level.create(:name => '8', :description => '8')
    Level.create(:name => '9', :description => '9')
    Level.create(:name => '10', :description => '10')
    Level.create(:name => '11', :description => '11')
    Level.create(:name => '12', :description => '12')
  end

  def self.down
    Level.delete_all
  end
  
end
