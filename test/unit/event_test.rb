require 'test_helper'

class EventTest < ActiveSupport::TestCase
  
  def setup
    @event = Event.new(:start_time => 1.hour.from_now, :end_time => 2.hours.from_now)
    @event_series = EventSeries.new(:title => 'title')
    @event_series.owner = users(:paru)
    @event_series.users << users(:shenu)
    @event_series.users << users(:reeny)
  end
  
  test "start time should precede end time" do
    e = Event.new(:start_time => 2.hours.from_now, :end_time => 1.hour.from_now)
    assert !e.valid?
    time = Time.now
    e = Event.new(:start_time => time, :end_time => time)
    assert !e.valid?
  end
  
  test "cannot save without event series" do
    assert !@event.save
    @event.event_series = @event_series
    assert @event.save
    @event.event_series.title = nil
    assert !@event.save
  end

end
