class EventSeries < ActiveRecord::Base
    
  validates_presence_of :frequency, :period, :start_time, :end_time
  
  has_many :events, :dependent => :destroy
  
end
