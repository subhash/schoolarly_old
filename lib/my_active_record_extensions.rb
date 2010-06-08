module MyActiveRecordExtensions
  
  def self.included(mod)
    mod.class_eval do
      extend ClassMethods
    end
  end
      
  module ClassMethods
    def create_or_update(options = {})
      id = options.delete(:id)
      record = find_by_id(id) || new
      record.id = id
      record.attributes = options
      record.save!
      record
    end
  end
end

#module ActiveRecord
#  class Base
#    extend MyActiveRecordExtensions
#  end
#end

#ActiveRecord::Base.send(:include, MyActiveRecordExtensions)

#ActiveRecord::Base.class_eval do
#  include MyActiveRecordExtensions
#end
#
#class ActiveRecord::Base
#  include MyActiveRecordExtensions
#end
#class ActiveRecord::Base
#self.send :include, MyActiveRecordExtensions
#end
#
#module ActiveRecord::Base
#    include MyActiveRecordExtensions
#end


