class SchoolarlyAdmin < ActiveRecord::Base
  has_one :user, :as => :person
  def add_roles
    
  end
end
