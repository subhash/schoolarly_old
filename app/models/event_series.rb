class EventSeries < ActiveRecord::Base
  has_many :events, :dependent => :destroy
  belongs_to :owner , :class_name => 'User', :foreign_key => 'user_id'
  has_and_belongs_to_many :users 
  
  validates_presence_of :title
  validates_associated :events
  
  named_scope :for_users, lambda {|user_ids, user_count|
    { :joins => "LEFT JOIN event_series_users eu ON eu.event_series_id = event_series.id ",
      :conditions => ["eu.user_id IN (?)", user_ids], :group => "event_series.id", :having => "count(*) > #{user_count}"
    }
  }
  
  def send_message
    event = self.reload.events.first
    body = self.description + event.start_time.strftime(" scheduled on %B %d, %Y at %I:%M %p ") + ((self.period == 'once') ? '' :  self.period) #TODO + ' for ' + interval(event.start_time, event.end_time)
    subject = 'Event Announcement: ' + self.title
    self.owner.send_message(self.users, body, subject) if !self.users.empty?
  end  
  
  validates_each :events do |event_series, attr, events|
    events.each do |event|
      unless event.start_time_before_end_time
        event.errors.add(:end_time, 'should precede start time')
        event_series.errors.add_to_base('End time should precede Start time')
      end      
    end
  end
  
  def create_events(start_time, end_time, recurrence = 'once')
    if (start_time and start_time < Event.last_day) 
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
