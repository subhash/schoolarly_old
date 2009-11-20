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
  
end

class Address
  # include ActiveRecord::Validations
  attr_reader :address_line1,  :address_line2,  :city,  :state,  :country,  :pincode,  :phone_landline,  :phone_mobile
  def initialize(address_line1,  address_line2,  city,  state,  country,  pincode,  phone_landline,  phone_mobile)
    @address_line1=address_line1
    @address_line2=address_line2
    @city=city
    @state=state
    @country=country  
    @pincode=pincode  
    @phone_landline=phone_landline  
    @phone_mobile =  phone_mobile
  end
  # validates_presence_of :address_line1,   :city,    :state,    :country
  #TODO validates_format_of pincode,landline,mobile  
end

class Name
  # include ActiveRecord::Validations
  attr_reader :first_name, :middle_name, :last_name
  def initialize(first_name, middle_name, last_name)
    @first_name=first_name
    @middle_name=middle_name
    @last_name=last_name
  end
  def is_valid?(errors)
    errors.add("first name should not be blank") if first_name.blank? 
    errors.add("last name should not be blank") if last_name.blank?
  end
  # validates_presence_of :first_name, :last_name
end
