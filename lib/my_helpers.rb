module MyHelpers
  
  def interval(start_time, end_time)
    hours, mins, ignore_secs, ignore_fractions = Date::day_fraction_to_time((end_time.to_time - start_time.to_time)/1.day)
    duration = ActionController::Base.helpers.pluralize(hours, 'hr') + ((mins > 0) ? ' ' + ActionController::Base.helpers.pluralize(mins, 'min') : '')
  end
 
end
