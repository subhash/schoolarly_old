class SchoolarlyAdmin < ActiveRecord::Base
  has_one :user, :as => :person
  
  def name
    user.name
  end

end
