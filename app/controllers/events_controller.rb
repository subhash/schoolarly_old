class EventsController < ApplicationController
  before_filter :set_up
  
  def set_up
    @users = current_user.person.school ? current_user.person.school.users : nil
  end
  
  def new
    @event = Event.new(:end_time => 1.hour.from_now, :period => "Does not repeat", :owner => current_user)
  end
  
  def create
    if params[:event][:period] == "Does not repeat"
      @event = Event.new(params[:event])
      @event.owner = current_user
      if @event.save!
        render :template => 'events/create'
      else
        render :template => 'events/create_error'
      end
    else
      #      @event_series = EventSeries.new(:frequency => params[:event][:frequency], :period => params[:event][:repeats], :start_time => params[:event][:start_time], :end_time => params[:event][:end_time], :all_day => params[:event][:all_day])
      @event_series = EventSeries.new(params[:event])
      @event_series.owner = current_user
      if @event_series.save!
        render :template => 'events/create'
      else
        render :template => 'events/create_error'
      end
    end
  end
  
  def index
  end
  
  
  def get_events   
    owned_events = current_user.owned_events.find(:all, :conditions => ["start_time >= '#{Time.at(params['start'].to_i).to_formatted_s(:db)}' and end_time <= '#{Time.at(params['end'].to_i).to_formatted_s(:db)}'"] )
    participated_events = current_user.events.find(:all, :conditions => ["start_time >= '#{Time.at(params['start'].to_i).to_formatted_s(:db)}' and end_time <= '#{Time.at(params['end'].to_i).to_formatted_s(:db)}'"] )
    @events = owned_events + participated_events
    events = [] 
    @events.each do |event|
      events << {:id => event.id, :title => event.title, :description => event.description || "Some cool description here...", :start => "#{event.start_time.iso8601}", :end => "#{event.end_time.iso8601}", :allDay => event.all_day, :recurring => event.recurring}
    end
    render :text => events.to_json
  end
  
  
  
  def move
    @event = Event.find_by_id params[:id]
    if @event
      @event.start_time = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.start_time))
      @event.end_time = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.end_time))
      @event.all_day = params[:all_day]
      @event.save
    end
  end
  
  
  def resize
    @event = Event.find_by_id params[:id]
    if @event
      @event.end_time = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.end_time))
      @event.save
    end    
  end
  
  def edit
    @event = Event.find_by_id(params[:id])
    @exam = Exam.find_by_event_id(@event.id)
  end
  
  def update
    @event = Event.find_by_id(params[:id])
    if params[:event][:commit_button] == "Update All Future Events"
      @events = @event.event_series.events.find(:all, :conditions => ["start_time > '#{@event.start_time.to_formatted_s(:db)}' "])
      @event.update_events(@events, params[:event])
    else
      @event.attributes = params[:event]
      @event.save
    end
    
    render :update do |page|
      page.close_dialog
      page<<"jQuery('#calendar').fullCalendar( 'refetchEvents' )"
    end
    
  end  
  
  def destroy
    @event = Event.find_by_id(params[:id])
    if params[:delete_all] == 'future'
      @events = @event.event_series.events.find(:all, :conditions => ["start_time > '#{@event.start_time.to_formatted_s(:db)}' "])
      @event.event_series.events.delete(@events)
    else
      @event.destroy
    end
    
    render :update do |page|
      page.close_dialog
      page<<"jQuery('#calendar').fullCalendar( 'refetchEvents' )" 
    end
    
  end
  
end
