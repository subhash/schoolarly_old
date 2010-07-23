class Event < ActiveRecord::Base 
  
  belongs_to :event_series
  
  validates_presence_of :start_time, :end_time
  validate :validate_start_time_before_end_time
  before_save :validate_event_series
  
  def send_message
    hours, mins, ignore_secs, ignore_fractions = Date::day_fraction_to_time((self.end_time.to_time - self.start_time.to_time)/1.day)
    duration = ActionController::Base.helpers.pluralize(hours, 'hr') + ((mins > 0) ? ' ' + ActionController::Base.helpers.pluralize(mins, 'min') : '')
    body = event_series.description + start_time.strftime(" re-scheduled to %B %d, %Y at %I:%M%p for " + duration)
    subject = 'Event Announcement: ' + event_series.title + ' re-scheduled'
    event_series.owner.send_message(event_series.users, body, subject) if !event_series.users.empty?
  end 
  
  def validate_start_time_before_end_time
    errors.add(:start_time, "start time should precede end time") unless start_time_before_end_time
  end
  
  def validate_event_series
    !event_series.nil? and event_series.valid?
  end
  
  def start_time_before_end_time
    self.start_time < self.end_time if (start_time and end_time)
  end
  
  # TODO Need to change to academic year 
  def self.last_day
    Time.now.next_year
  end
  
  def self.now
    time = Time.zone.now
    time.advance(:minutes => (5 - time.min % 5))
  end
  
  def activity
    Activity.find_by_event_id(id)
  end
  
  def editable
    activity ? false : true
  end
  
end
