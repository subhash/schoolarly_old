class EventsController < ApplicationController
  
  def new    
    @event = Event.new(:start_time => 1.hour.from_now, :end_time => 2.hour.from_now)
    @event.event_series = EventSeries.new( :owner => current_user)
    @users = current_user.person.school ? current_user.person.school.users - [current_user] : nil
  rescue Exception => e
    puts e.backtrace
  end
  
  def create
    @event = Event.new(params[:event])
    puts 'event - '+params[:event].inspect
    @event.event_series.owner = current_user
    @event.event_series.period = params[:repeat]
    @event.event_series.frequency = 1
    if @event.save
      @event.propagate
      render :template => 'events/create'
    else
      render :template => 'events/create_error'
    end
  end
  
  def index
    respond_to do |wants|
      wants.html { render }
      wants.js {
        @events = [] 
        current_user.event_series.each {|es| @events += es.events.find(:all, :conditions => ["start_time >= '#{Time.at(params['start'].to_i).to_formatted_s(:db)}' and end_time <= '#{Time.at(params['end'].to_i).to_formatted_s(:db)}'"] )}
        current_user.owned_event_series.each {|es| @events += es.events.find(:all, :conditions => ["start_time >= '#{Time.at(params['start'].to_i).to_formatted_s(:db)}' and end_time <= '#{Time.at(params['end'].to_i).to_formatted_s(:db)}'"] )}
        events = @events.collect { |e| {:id => e.id, :title => e.title, :description => e.description || "Some cool description here...", :allDay => false, :start => "#{e.start_time.iso8601}", :end => "#{e.end_time.iso8601}"}}
        render :text => events.to_json
      }
    end
  rescue Exception => e
    puts e.backtrace
  end  
  
  
  def alter
    @event = Event.find_by_id params[:id]
    if @event
      @event.start_time = @event.start_time.advance(:minutes => params[:minute_delta].to_i, :days => params[:day_delta].to_i)
      @event.end_time = @event.end_time.advance(:minutes => params[:minute_delta].to_i, :days => params[:day_delta].to_i)
      @event.event_series = EventSeries.new(:owner => @event_series.owner, :users => @event_series.users)
      @event.save
      @event_series.destroy if @event_series.events.size == 0
    end
  end
  
  def edit
    @event = Event.find_by_id(params[:id])
    @exam = Exam.find_by_event_id(@event.id)
    @users = current_user.person.school ? current_user.person.school.users - [current_user] : nil
  end
  
  def update    
    @event = Event.find(params[:id])
    users = params[:users] || []
    start_time = @event.start_time
    end_time = @event.end_time
    @event.attributes = params[:event]    
    st = start_time - @event.start_time
    et = end_time - @event.end_time
    old_event_series = @event.event_series   
    
    new_event_series = EventSeries.new(:owner => current_user, :users => users.collect {|id| User.find(id)})
    
    if (params[:update_scope] == "future")
      @events = old_event_series.events.find(:all, :conditions => ["start_time > '#{@event.start_time.to_formatted_s(:db)}' "])
      @events.each do |event|
        event.title = @event.title
        event.description = @event.description
        event.start_time += st
        event.end_time += et    
        event.event_series = new_event_series  
        event.save
      end
    end
    
    @event.event_series = new_event_series
    @event.save      
    old_event_series.destroy if old_event_series.events.size == 0   
    
    render :update do |page|
      page.close_dialog
      page<<"jQuery('#calendar').fullCalendar( 'refetchEvents' )"
    end
  rescue Exception => e
    puts e.inspect
    puts e.backtrace
  end  
  
  def destroy
    @event = Event.find_by_id(params[:id])
    if params[:delete_all] == 'future'
      @events = @event.event_series.events.find(:all, :conditions => ["start_time > '#{@event.start_time.to_formatted_s(:db)}' "])
      @event.event_series.events.delete(@events)
    end
    @event.destroy
    @event.event_series.destroy if @event.event_series.events.size == 0
    
    render :update do |page|
      page.close_dialog
      page<<"jQuery('#calendar').fullCalendar( 'refetchEvents' )" 
    end
    
  end
  
end
