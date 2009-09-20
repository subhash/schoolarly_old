require 'test_helper'

class SchoolTest < ActiveSupport::TestCase
  #fixtures :users,:schools
  
  def setup
    #    @user = User.new(  :first_name=> "St.Teresas",
    #  :last_name=> "Admin",
    #  :address_line1=> "Convent Jn.",
    #  :city=> "Kochi"
    #  :state=> "Kerala"
    #  :country=> "India"
    #  :pincode=> "682011"
    #  :phone_landline=> "0484-1234567"
    #  :email=> "admin@st_teresas.com"
    #    )
    @user = users(:admin_st_teresas)
    @school = schools(:st_teresas)
  end
  
  test "school-user association" do        
    @school.user = @user
    assert @user.save!
    assert_equal @user.person, @school
  end
  
  test "user-school association" do    
    @user.person = @school
    assert @school.save
    assert_equal @user.person, @school
  end
end
