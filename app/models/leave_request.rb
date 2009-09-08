class LeaveRequest < ActiveRecord::Base
  belongs_to :parent, :class_name => 'Parent', :foreign_key => :parent_id
  has_one :student, :through => :parent  
end
