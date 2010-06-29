class User < ActiveRecord::Base

  acts_as_authentic do |c|
    option = {:if => Proc.new {|user| user.perishable_token.nil? }}
    c.validates_length_of_password_field_options =  validates_length_of_password_field_options.merge(option)
    c.validates_length_of_password_confirmation_field_options = validates_length_of_password_confirmation_field_options.merge(option)
    c.perishable_token_valid_for(0)
  end
  
  acts_as_messageable
  
  belongs_to :person, :polymorphic => true
  has_one :user_profile
  has_and_belongs_to_many :event_series
  has_many :owned_event_series, :class_name => 'EventSeries'
  
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
  
  def role_symbols
    [person.class.name.underscore.to_sym]
  end
  
  def self.with_permissions_to(privilege)
    self.all.select do |object|
      Authorization::Engine.instance.permit?(privilege, :object => object.person)#, :context => object.person.class.name.underscore.pluralize.to_sym)
    end
  end  
end