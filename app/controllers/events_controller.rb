class EventsController < ApplicationController
  
  def new
    @users = current_user.person.school ? current_user.person.school.users : nil
    @event = Event.new(:end_time => 1.hour.from_now)
    @event.event_series = EventSeries.new( :owner => current_user)
    @periods = ['', 'days', 'weeks', 'months']
  rescue Exception => e
    puts e.backtrace
  end
  
  def create
    @event = Event.new(params[:event])
    @event.event_series.owner = current_user
    @event.event_series.period = params[:repeat] unless params[:repeat] == 'once'
    @event.event_series.frequency = 1
    @event.propagate
    if @event.save
      render :template => 'events/create'
    else
      render :template => 'events/create_error'
    end
  end
  
  def index
    respond_to do |wants|
      wants.html { render }
      wants.js {
        #        owned_events = current_user.owned_events.find(:all, :conditions => ["start_time >= '#{Time.at(params['start'].to_i).to_formatted_s(:db)}' and end_time <= '#{Time.at(params['end'].to_i).to_formatted_s(:db)}'"] )
        #        participated_events = current_user.events.find(:all, :conditions => ["start_time >= '#{Time.at(params['start'].to_i).to_formatted_s(:db)}' and end_time <= '#{Time.at(params['end'].to_i).to_formatted_s(:db)}'"] )
        #        @events = owned_events + participated_events
        @events = [] 
        current_user.event_series.each {|es| @events += es.events}
        current_user.owned_event_series.each {|es| @events += es.events}
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
      @event.save
    end
  end
  
  def edit
    @event = Event.find_by_id(params[:id])
    @exam = Exam.find_by_event_id(@event.id)
  end
  
  def update
    e = Event.new(params[:event])
    @event = Event.find(params[:id])    
    @events = @event.event_series.events.find(:all, :conditions => ["start_time > '#{@event.start_time.to_formatted_s(:db)}' "])
    st = e.start_time-@event.start_time
    et = e.end_time - @event.end_time  
    
    @event.copy_attr(e)
    @event.start_time += st
    @event.end_time += et
    @event.save
    
    if (params[:update_scope] == "2")
      @events.each do |event|
        event.copy_attr(e)
        event.start_time += st
        event.end_time += et      
        event.save
      end
    end    
    
    render :update do |page|
      page.close_dialog
      page<<"jQuery('#calendar').fullCalendar( 'refetchEvents' )"
    end
  rescue Exception => e
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
