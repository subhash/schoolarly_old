class Event < ActiveRecord::Base
  
  validates_presence_of :title, :description
  
  belongs_to :initiator , :class_name => :user
  belongs_to :event_series
  
  has_and_belongs_to_many :invitees , :class_name => :user, :association_foreign_key => 'user_id'
  
  attr_accessor :period, :frequency, :commit_button
  
  
  REPEATS = [
              "Does not repeat",
              "Daily"          ,
              "Weekly"         ,
              "Monthly"        ,
              "Yearly"         
  ]
  
  def validate
    if (start_time >= end_time) and !all_day
      errors.add_to_base("Start Time must be less than End Time")
    end
  end
  
  def update_events(events, event)
    events.each do |e|
      begin 
        st, et = e.start_time, e.end_time
        e.attributes = event
        if event_series.period.downcase == 'monthly' or event_series.period.downcase == 'yearly'
          nst = DateTime.parse("#{e.start_time.hour}:#{e.start_time.min}:#{e.start_time.sec}, #{e.start_time.day}-#{st.month}-#{st.year}")  
          net = DateTime.parse("#{e.end_time.hour}:#{e.end_time.min}:#{e.end_time.sec}, #{e.end_time.day}-#{et.month}-#{et.year}")
        else
          nst = DateTime.parse("#{e.start_time.hour}:#{e.start_time.min}:#{e.start_time.sec}, #{st.day}-#{st.month}-#{st.year}")  
          net = DateTime.parse("#{e.end_time.hour}:#{e.end_time.min}:#{e.end_time.sec}, #{et.day}-#{et.month}-#{et.year}")
        end
        #puts "#{nst}           :::::::::          #{net}"
      rescue
        nst = net = nil
      end
      if nst and net
        #          e.attributes = event
        e.start_time, e.end_time = nst, net
        e.save
      end
    end
    
    event_series.attributes = event
    event_series.save
  end  
  
  
end
