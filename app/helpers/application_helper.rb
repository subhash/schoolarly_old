# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def toggle_div(div)
    update_page do |page|
      page[div].toggle
    end
  end
  
  def lay_tabs(*tabs)
    render :partial => "layouts/tabs", :locals => {:tabs => tabs}
  end
  
  def render_show(*options)
    render :partial => "layouts/show_template", :locals => {:options => options}
  end
end
