class User < ActiveRecord::Base
  
  acts_as_authentic do |c|
    option = {:if => Proc.new {|user| user.perishable_token.nil? }}
    c.validates_length_of_password_field_options =  validates_length_of_password_field_options.merge(option)
    c.validates_length_of_password_confirmation_field_options = validates_length_of_password_confirmation_field_options.merge(option)
  end
  
  belongs_to :person, :polymorphic => true
  has_one :user_profile 
  
  has_and_belongs_to_many :events
  
  def name
    user_profile ? user_profile.name : email
  end
  
  def deliver_password_reset_instructions!  
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)    
  end
  
  def deliver_invitation!  
    reset_perishable_token
    save_without_session_maintenance(true) and Notifier.deliver_invitation(self)    
  end
  
  acts_as_messageable
  
end