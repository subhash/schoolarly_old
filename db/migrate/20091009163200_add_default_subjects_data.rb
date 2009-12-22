class AddDefaultSubjectsData < ActiveRecord::Migration
  def self.up        
    Subject.create(:name => "English")
    Subject.create(:name => "Malayalam")
    Subject.create(:name => "Hindi")
    Subject.create(:name => "Tamil")
    Subject.create(:name => "Kannada")
    Subject.create(:name => "Sanskrit")
    Subject.create(:name => "Mathematics")
    Subject.create(:name => "Physics")
    Subject.create(:name => "Chemistry")
    Subject.create(:name => "Biology")
    Subject.create(:name => "Social Science")
    Subject.create(:name => "History")
    Subject.create(:name => "Geography")
    Subject.create(:name => "Economics")
    Subject.create(:name => "Civics")
    Subject.create(:name => "Computer Science")
    Subject.create(:name => "Zoology")
    Subject.create(:name => "Botany")
    Subject.create(:name => "Commerce")
    Subject.create(:name => "Literature")    
    Subject.create(:name => "Music")
    Subject.create(:name => "Drawing")
    Subject.create(:name => "Physical Training")
  end

  def self.down
    Subject.delete_all
  end
end
