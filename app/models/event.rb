class Event < ActiveRecord::Base
  
    
  validates_presence_of :title, :description

  belongs_to :initiator , :class_name => :user
  belongs_to :event_series
  
  #has_and_belongs_to_many :invitees , :class_name => :user
  
  def validate
    if (start_time >= end_time) and !all_day
      errors.add_to_base("Start Time must be less than End Time")
    end
  end
  
  
end
