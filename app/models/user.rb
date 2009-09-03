class User < ActiveRecord::Base
  composed_of :name
  composed_of :address
  validates_presence_of :email, :person_type
  validates_uniqueness_of :email
  validates_associated :name, :address
#  validates_confirmation_of :password
#  validate :password_non_blank
#  attr_accessor :password_confirmation
  
  private
  def password_non_blank
    errors.add(:password, "Missing password") if hashed_password.blank?
  end
  
  
  # validates_format_of :email, :with => %r{(.+)@(.+)(\.(.{1,3})){1,2}$}i, :message => "Invalid email id"
  #validates_format_of(:pincode, :with => "", :message => " Invalid zipcode"  )

  #TODO validates_length_of :password, :minimum => 6, :maximum => 25, :message => "Password should be ..."
  #TODO validates_format_of :password, :with => %r{[A-Z]}

end

class Address
  include ActiveRecord::Validations
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
  validates_presence_of :address_line1,   :city,    :state,    :country
  #TODO validates_format_of pincode,landline,mobile  
end

class Name
  include ActiveRecord::Validations
  attr_reader :first_name, :middle_name, :last_name
  def initialize(first_name, middle_name, last_name)
    @first_name=first_name
    @middle_name=middle_name
    @last_name=last_name
  end
  validates_presence_of :first_name, :last_name
end
