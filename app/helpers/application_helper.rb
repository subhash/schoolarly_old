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
  
  def is_messageable?
    persons=['schools','teachers','students']
    return controller.action_name == 'show' && persons.include?(controller.controller_name)
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
        if(args[:tab])
          tab = args[:tab]
        elsif(args[:title])
          tab = args[:title].parameterize
        else
          raise Error.new
        end
        @tabs ||= []
        tab_args = {}
        tab_args[:tab] = tab
        tab_args[:title] = args[:title]
        args.delete(:tab)
        args.delete(:title)
        tab_args[:render] = args        
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
      
    end
    yield tabbifier if block_given?
    concat(render :partial => "/common/tabs", :object => tabbifier.tabs)
  end
end

module ActionView
  module Helpers    
    module PrototypeHelper
      class JavaScriptGenerator
        module GeneratorMethods         
          
         def open_dialog(title, args)
             call "openModalbox", render(args), title
         end
         
         def close_dialog
           call "closeModalbox"
         end
         
         def refresh_dialog(args)
           call "refreshModalbox", render(args)
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
