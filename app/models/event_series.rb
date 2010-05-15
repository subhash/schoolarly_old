class EventSeries < ActiveRecord::Base
  
  has_many :events, :dependent => :destroy
  belongs_to :owner , :class_name => 'User', :foreign_key => 'user_id'
  has_and_belongs_to_many :users  
  
  def create_events(start_time, end_time, recurrence = nil)
    if (start_time < Event.last_day) 
      event = Event.new
      event.start_time = start_time
      event.end_time = end_time
      puts 'event - '+event.inspect
      self.events << event
      unless recurrence == 'once'
        create_events(start_time.advance(recurrence.to_sym => 1), end_time.advance(recurrence.to_sym => 1), recurrence)
      end
    end
  end
  
  def add_event(event, st, et)
    event.start_time += st
    event.end_time += et
    self.events << event 
  end
  
end
