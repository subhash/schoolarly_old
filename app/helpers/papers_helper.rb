module PapersHelper
  
  def text_method_for(entity)
    entity.class.name == 'Teacher'? :desc : :name
  end
  
end
