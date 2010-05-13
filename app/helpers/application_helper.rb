# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def toggle_div(div)
    update_page do |page|
      page[div].toggle
    end
  end
  
  def render_message_if_empty(collection, message)
    if collection.nil? || collection.empty?
      render :text => '<br/><blockquote>' + message + '</blockquote>'
    end
  end
  
  def is_messageable?(person)
    return current_user && (current_user.person.is_a?(SchoolarlyAdmin) || (person.school && (person.school == current_user.person.school unless current_user.person.is_a?(SchoolarlyAdmin))))
  end
  
  def active_controller
    contexts = ['schools', 'users', 'teachers', 'students', 'klasses']
    contexts.each do |context|
      if session[:redirect].include?(context)
        return context 
      end
    end
    return nil
  end
  
  def profile_link(entity)
    if entity.user.user_profile
      return link_to entity.name, entity
    else
      return link_to "Profile not created", {:controller => 'user_profiles', :action => 'new', :id => entity.user}, {:class => "profile"} 
    end
  end
  
  def render_tabs    
    tabbifier = Object.new  
    
    class <<tabbifier
      attr_accessor :tabs
      def tab(args)
        tab = args.delete(:tab)
        title = args.delete(:title)
        tab = title.parameterize unless tab
        tab_args = {}
        tab_args[:tab] = tab
        tab_args[:title] = title        
        tab_args[:header] = args.delete(:header)
        tab_args[:render] = args        
        @tabs ||= []
        @tabs << tab_args
      end
      
      def students_tab(args={})
        new_args = {:tab => :students, :title => 'Students', :partial => 'students/students', :object => @students } 
        tab new_args.merge(args)
      end
      
      def klasses_tab(args={})
        new_args = {:tab => :klasses, :title => 'Classes', :partial => 'klasses/klasses', :object => @klasses } 
        tab new_args.merge(args)
      end
      
      def teachers_tab(args={})
        new_args = {:tab => :teachers, :partial => 'teachers/teachers', :object => @teachers } 
        tab new_args.merge(args)
      end

      def papers_tab(args={})
        new_args = {:tab => :papers, :title => 'Subjects', :partial => 'papers/papers', :object => @papers } 
        tab new_args.merge(args)
      end     
      
      def exams_tab(args={})
        new_args = {:tab => :exams, :partial => 'exam_groups/exam_groups' }
        tab new_args.merge(args)
      end
      
      def messages_tab(args={})
        mailboxes = ['inbox', 'sentbox', 'trash']
        new_args = {:tab => :messages, :title => 'My Messages', :partial => 'mails/mailboxes', :object => mailboxes, :header => {:partial => 'mails/messages_header', :locals => {:mailboxes => mailboxes} } }
        tab new_args.merge(args)
      end

      def events_tab(args={})
        new_args = {:title => 'My Events', :partial => 'events/calendar'} 
        tab new_args.merge(args)
      end
      
    end
    yield tabbifier if block_given?
    concat(render :partial => "/common/tabs", :object => tabbifier.tabs) if tabbifier.tabs
  end
  
  def render_actions(&block)
    collector = self
    class <<collector
      def link(title, args)
        concat(render :partial => "/common/action_link", :locals => {:title => title, :args => args})
      end
      def dialog(title, args)
        concat(render :partial => '/common/action', :locals => {:title => title, :args => args})
      end
    end
    concat(render :partial => '/common/actions', :locals => {:block => block, :collector => collector })
  end
  
  def render_breadcrumbs(&block)
    collector = self
    class <<collector
      def crumb(label, url = nil)
        concat(render :partial => '/common/crumb', :locals => {:url => url, :label => label})
      end
      
      def crumb_for(person)
        case
          when person.is_a?(Teacher)
            self.crumb(person.school.name, person.school) if person.school
          when person.is_a?(Student)
            self.crumb(person.school.name, person.school) if person.school
            self.crumb(person.klass.name, person.klass)if person.school and person.klass              
        end
        self.crumb(person.name, person)
      end
    end
    concat(render :partial => '/common/crumbs', :locals => {:block => block, :collector => collector})
  end
  
end

module ActionView
  module Helpers    
    module PrototypeHelper
      class JavaScriptGenerator
        module GeneratorMethods         
          
         def refresh
           call 'window.location.reload'
         end
         
         def open_dialog(title, args, height = nil)
           if(height)
             call "openModalbox", render(args), title, height
           else
             call "openModalbox", render(args), title
           end
         end
         
         def close_dialog
           call "closeModalbox"
         end
         
         def refresh_dialog(args, height = nil)
           if(height)
              call "refreshModalbox", render(args), height
           else
              call "refreshModalbox", render(args)
           end
         end
         
         def error_dialog(error)
           call "refreshModalbox", "<html><body><h3>#{error}</h3></body></html>"
         end
         
         def open_tab(obj)
           call 'openTab', css_class_id(obj)
         end
         
         def replace_tab(obj, args)
           replace_html css_class_id(obj) + "-tab", args
           open_tab(obj)
         end
         
         # page.insert_object obj, :position => :top, :insert_id => 'messages', :partial => ..
         # position, insert_id are optional
         #         
         def insert_object(obj, args)
           args[:object] = obj
           position = args.delete(:position) || :bottom
           insert_id = args.delete(:insert_id) || css_class_id(obj) 
           insert_html position, insert_id, args
           show insert_id
         end
         
         def remove_object(obj)           
           self[css_id(obj)].remove 
         end
         
         def replace_object(obj, args) 
           args[:object] = obj
           replace css_id(obj), args   
         end
         
         def replace_action(title, args)
           replace title.parameterize.to_s, :partial => '/common/action', :locals => {:title => title, :args => args}
         end
         
         def replace_header
           replace "header", :partial => '/common/header'
         end
         
         private
         def css_id(obj)
           "#{obj.class.name.downcase}-#{obj.id}"
         end
         
         def css_class_id(class_obj)
           class_obj = class_obj.class unless class_obj.kind_of? Class
           class_obj.name.downcase.pluralize
         end
       
        end
      end
    end
  end
end
