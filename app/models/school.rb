class School < ActiveRecord::Base
  has_one :user, :as => :person
end
