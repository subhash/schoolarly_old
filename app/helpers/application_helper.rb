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
        new_args = {:tab => :teachers, :title => 'Teachers', :partial => 'teachers/teachers', :object => @teachers } 
        tab new_args.merge(args)
      end

      def papers_tab(args={})
        new_args = {:tab => :papers, :title => 'Subjects', :partial => 'papers/papers', :object => @papers } 
        tab new_args.merge(args)
      end     
      
      def exams_tab(args={})
        new_args = {:tab => :exams, :title => 'Exams', :partial => 'exam_groups/exam_groups', :object => @exam_groups } 
        tab new_args.merge(args)
      end
      
      def scores_tab(args={})
        new_args = {:tab => :scores, :title => 'Scores', :partial => 'scores/scores'} 
        tab new_args.merge(args)
      end
      
    end
    yield tabbifier if block_given?
    concat(render :partial => "/common/tabs", :object => tabbifier.tabs)
  end
end
