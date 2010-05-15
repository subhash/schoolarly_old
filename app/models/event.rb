class Event < ActiveRecord::Base
  
  
  belongs_to :event_series
  
  accepts_nested_attributes_for :event_series
  
  def propagate
    period = event_series.period
    frequency = event_series.frequency
    puts 'propagating period '+period.blank?.inspect
    template = self
    puts 'template - '+template.start_time.inspect
    puts 'last day - '+Event.last_day.inspect
    puts 'results - '+(template.start_time < Event.last_day).inspect
    while (template.start_time < Event.last_day) and period != 'once' 
      event = Event.new
      event.copy_attr(self)
      event.start_time = template.start_time.advance(period.to_sym => frequency)
      event.end_time = template.end_time.advance(period.to_sym => frequency)
      self.event_series.events << event
      puts 'updated - '+event.inspect
      template = event      
    end
  end
  
  def copy_attr(event)
    self.title = event.title
    self.description = event.description
  end
  
  # TODO Need to change to academic year 
  def self.last_day
    Time.now.next_year
  end
  
end
