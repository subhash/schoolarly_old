class User < ActiveRecord::Base
  
  acts_as_authentic do |c|
    option = {:if => Proc.new {|user| user.perishable_token.nil? }}
    c.validates_length_of_password_field_options =  validates_length_of_password_field_options.merge(option)
    c.validates_length_of_password_confirmation_field_options = validates_length_of_password_confirmation_field_options.merge(option)
  end
  
  # Authorization plugin
  acts_as_authorized_user
  acts_as_authorizable
  
  belongs_to :person, :polymorphic => true
  has_one :user_profile
  
  after_create :add_roles  
  
  def name
    user_profile ? user_profile.name : email
  end
  
  def add_roles
    self.has_role 'editor', self.person if self.person
    add_roles_for_person
  end
  
  def add_roles_for_person    
    # Ensure person association and that roles are added
    return (person and self.person.add_roles)    
  end
  
  def invite!()
    reset_perishable_token
    save_before_invite and  Notifier.deliver_invitation(self)
  end
  
  def save_before_invite
    self.skip_session_maintenance = true
    result = save!
    self.skip_session_maintenance = false
    result
  end
  
  def deliver_password_reset_instructions!  
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)    
  end  
  
  acts_as_messageable
  
end