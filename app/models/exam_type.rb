class ExamType < ActiveRecord::Base
  has_many :exam_groups
end
