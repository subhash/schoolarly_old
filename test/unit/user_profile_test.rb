require 'test_helper'

class UserProfileTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:user_without_profile)
    @stteresas = user_profiles(:stTeresas)
  end 
  
  test "profile belongs to user" do
    assert_nil @user.user_profile
    assert_difference('UserProfile.count', 1) do
      user_profile = UserProfile.create(:name => 'Paru', :user => @user)
      @user.user_profile = user_profile
      user_profile.user = @user
    end
  end
  
  test "validate presence of name" do
    profile_valid = UserProfile.new(:name => 'name', :user => @user)
    profile_invalid = UserProfile.new(:user => @user)
    assert profile_valid.valid?
    assert !profile_invalid.valid?
  end
  
  test "address should give the entire address of the profile seperated by comma" do
    assert_equal 'St Teresas Convent, Convent Junction, Kochi, Kerala, India', @stteresas.address.to_s
  end

end
