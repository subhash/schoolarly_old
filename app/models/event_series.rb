class EventSeries < ActiveRecord::Base
  attr_accessor :title, :description, :commit_button, :owner
  
  validates_presence_of :frequency, :period, :start_time, :end_time
  validates_presence_of :title, :description
  
  has_many :events, :dependent => :destroy
  
  def after_create
    create_events_until(END_TIME_EVENT_SERIES)
  end
  
  def create_events_until(end_time_event_series)
    st = start_time
    et = end_time
    p = r_period(period)
    nst, net = st, et
    
    while frequency.send(p).from_now(st) <= end_time_event_series
#      puts "#{nst}           :::::::::          #{net}" if nst and net
      self.events.create(:title => title, :description => description, :all_day => all_day, :start_time => nst, :end_time => net, :owner => owner)
      nst = st = frequency.send(p).from_now(st)
      net = et = frequency.send(p).from_now(et)
      
      if period.downcase == 'monthly' or period.downcase == 'yearly'
        begin 
          nst = DateTime.parse("#{start_time.hour}:#{start_time.min}:#{start_time.sec}, #{start_time.day}-#{st.month}-#{st.year}")  
          net = DateTime.parse("#{end_time.hour}:#{end_time.min}:#{end_time.sec}, #{end_time.day}-#{et.month}-#{et.year}")
        rescue
          nst = net = nil
        end
      end
    end
  end
  
  def r_period(period)
    case period
      when 'Daily'
      p = 'days'
      when "Weekly"
      p = 'weeks'
      when "Monthly"
      p = 'months'
      when "Yearly"
      p = 'years'
    end
    return p
  end
  
end
