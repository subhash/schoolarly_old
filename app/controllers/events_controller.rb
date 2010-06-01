class EventsController < ApplicationController
  
  def new    
    @event = Event.new(:start_time => Event.now, :end_time => Event.now.advance(:hours => 1))
    @event_series = EventSeries.new( :owner => current_user)
    @users = current_user.person.school ? current_user.person.school.users - [@event_series.owner] : nil
    render :update do |page|      
      page.open_dialog 'New Event', {:partial => 'create_form'}, 500
    end
  end
  
  def create
    @event_series = EventSeries.new(params[:event_series])    
    @event_series.owner = current_user
    @event = Event.new(params[:event])
    @event_series.create_events(@event.start_time, @event.end_time, params[:recurrence])
    if @event_series.save
      render :template => 'events/create'
    else
      render :update do |page|
        page.refresh_dialog :partial => 'create_form'
      end
    end
  rescue Exception => e
    puts e.inspect
    puts e.backtrace
  end
  
  def edit
    session[:redirect] = request.request_uri
    @event = Event.find_by_id(params[:id])
    @event_series = @event.event_series
    @exam = @event.exam
    if @exam
       @teachers = @exam.school.teachers
       render :template => "exams/edit"
    else
      @users = current_user.person.school ? current_user.person.school.users - [@event_series.owner] : nil
      render :update do |page|
        page.open_dialog @event_series.title, {:partial => 'events/edit_form'}, 500
      end
    end
  end
  
  def update    
    @event = Event.find(params[:id])
    old_event_series = @event.event_series
    new_event_series = old_event_series.clone
    new_event_series.attributes = params[:event_series]    
    event_input = Event.new(params[:event])
    st = event_input.start_time - @event.start_time
    et = event_input.end_time - @event.end_time    
    
    new_event_series.add_event(@event, st, et)    
    if (params[:update_scope] == "future")
      @events = old_event_series.events.find(:all, :conditions => ["start_time > '#{@event.start_time.to_formatted_s(:db)}' "])
      @events.each do |event|
        new_event_series.add_event(event, st, et)
      end
    end
    
    if new_event_series.save
      old_event_series.destroy if old_event_series.events.size == 0
      render :template => 'events/update'
    else
      render :update do |page|
        page.refresh_dialog :partial => 'edit_form'
      end
    end
  end  
  
  
  def index
    respond_to do |wants|
      wants.html { render }
      wants.js {
        @events = [] 
        current_user.event_series.each {|es| @events += es.events.find(:all, :conditions => ["start_time >= '#{Time.at(params['start'].to_i).to_formatted_s(:db)}' and end_time <= '#{Time.at(params['end'].to_i).to_formatted_s(:db)}'"] )}
        current_user.owned_event_series.each {|es| @events += es.events.find(:all, :conditions => ["start_time >= '#{Time.at(params['start'].to_i).to_formatted_s(:db)}' and end_time <= '#{Time.at(params['end'].to_i).to_formatted_s(:db)}'"] )}
        events = @events.collect { |e| {:id => e.id, :title => e.event_series.title, :description => e.event_series.description || "Some cool description here...", :allDay => false, :editable => e.editable, :start => "#{e.start_time.iso8601}", :end => "#{e.end_time.iso8601}"}}
        render :text => events.to_json
      }
    end
  end  
  
  
  def alter
    @event = Event.find(params[:id])
    @event_series = @event.event_series
    if @event
      @event.start_time = @event.start_time.advance(:minutes => params[:minute_delta].to_i, :days => params[:day_delta].to_i)
      @event.end_time = @event.end_time.advance(:minutes => params[:minute_delta].to_i, :days => params[:day_delta].to_i)
      @event.event_series = EventSeries.new(:title => @event_series.title, :description => @event_series.description, :owner => @event_series.owner, :users => @event_series.users)
      @event.save
      @event_series.destroy if @event_series.events.size == 0
    end
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
