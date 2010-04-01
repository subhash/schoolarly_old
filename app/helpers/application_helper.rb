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
end
