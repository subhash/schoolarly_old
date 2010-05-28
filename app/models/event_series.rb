class EventSeries < ActiveRecord::Base
  
  has_many :events, :dependent => :destroy
  belongs_to :owner , :class_name => 'User', :foreign_key => 'user_id'
  has_and_belongs_to_many :users 
  
  validates_presence_of :title
  
  validates_each :events do |event_series, attr, events|
    events.each do |event|
      unless event.start_time_before_end_time
        event.errors.add(:end_time, 'should precede start time')
        event_series.errors.add_to_base('End time should precede Start time')
      end      
    end
  end
  
  
  def create_events(start_time, end_time, recurrence = 'once')
    if (start_time < Event.last_day) 
      event = Event.new
      event.start_time = start_time
      event.end_time = end_time
      self.events << event
      yield event if block_given?
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
