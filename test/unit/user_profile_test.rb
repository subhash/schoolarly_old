require 'test_helper'

class UserProfileTest < ActiveSupport::TestCase
  
  def setup
    @paru=users(:paru)
    @stTeresas=user_profiles(:stTeresas)
  end
  
  test "cannot create a profile without first & last names" do
    assert_nil @paru.user_profile
    paru_profile = UserProfile.new(:middle_name =>'Middle')
    paru_profile.user = @paru
    paru_profile.save
    assert !paru_profile.valid?
  end
  
  test "profile-create" do
    assert_nil @paru.user_profile
    paru_profile = UserProfile.new(:first_name =>'First', :last_name =>'Last', :user => @paru)
    assert paru_profile.valid?
    paru_profile.save!
    assert paru_profile.valid?
    assert_equal 'First Last', paru_profile.name.to_s
  end
  
  test "address should give the entire address of the profile seperated by comma" do
    assert_equal 'St Teresas Convent, Convent Junction, Kochi, Kerala, India', @stTeresas.address.to_s
  end
  
  test "name should give the entire name of the user seperated by space" do
    assert_equal 'admin of stTeresas', @stTeresas.name.to_s
  end
end
