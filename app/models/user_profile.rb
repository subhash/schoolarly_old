class UserProfile < ActiveRecord::Base
  belongs_to :user
  composed_of :name, :class_name => "Name", :mapping => [ %w[ first_name first_name ],%w[ middle_name middle_name ],%w[ last_name last_name ]]
  composed_of :address, :class_name => "Address", 
              :mapping => [
                            %w[address_line_1 address_line_1],
                            %w[address_line_2 address_line_2],
                            %w[city city],
                            %w[state state],
                            %w[country country],
                            %w[pincode pincode],
                            %w[phone_landline phone_landline],
                            %w[phone_mobile phone_mobile]
                          ]
  
  validate :valid_name
  #TODO validates_presence_of :address_line_1, :city, :state, :country
  #TODO validates_format_of(:pincode, :with => "", :message => "Invalid Zip Code")
  #TODO validates_format_of (:phone_landline, :with => "", :message => "Invalid Telephone Number")
  #TODO validates_format_of (:phone_mobile, :with => "", :message => "Invalid Mobile Number")
   
  private
  def valid_name
    errors.add(:name, "Missing Name") if name.nil?
    name.is_valid?(errors)
  end
 
end

class Address
  
  attr_reader :address_line_1,  :address_line_2,  :city,  :state,  :country,  :pincode,  :phone_landline,  :phone_mobile
  
  def initialize(address_line_1,  address_line_2,  city,  state,  country,  pincode,  phone_landline,  phone_mobile)
    @address_line_1=address_line_1
    @address_line_2=address_line_2
    @city=city
    @state=state
    @country=country  
    @pincode=pincode  
    @phone_landline=phone_landline  
    @phone_mobile =  phone_mobile
  end
  
  def to_s
    [ @address_line_1, @address_line_2, @city, @state, @country ].join(', ')
  end
 
end

class Name
  
  attr_reader :first_name, :middle_name, :last_name
  
  def initialize(first_name, middle_name, last_name)
    @first_name=first_name
    @middle_name=middle_name
    @last_name=last_name
  end
  
  def is_valid?(errors)
    errors.add("First Name should not be blank") if first_name.blank? 
    errors.add("Last Name should not be blank") if last_name.blank?
  end
  
  def to_s
    [ @first_name, @middle_name, @last_name ].compact.join(" ")
  end
  
end
