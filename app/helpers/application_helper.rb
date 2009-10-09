# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def toggle_div(div)
    update_page do |page|
      page[div].toggle
    end
  end
end
