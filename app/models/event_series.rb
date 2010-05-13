class EventSeries < ActiveRecord::Base
  
  has_many :events, :dependent => :destroy
  belongs_to :owner , :class_name => 'User', :foreign_key => 'user_id'
  has_and_belongs_to_many :users  
  
end
