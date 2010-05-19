require 'test_helper'

class UserProfileTest < ActiveSupport::TestCase
  
  def setup
    @paru = users(:paru)
    @stTeresas = user_profiles(:stTeresas)
  end
  
  test "profile-create" do
    assert_nil @paru.user_profile
    paru_profile = UserProfile.new(:name =>'Name', :user => @paru)
    assert paru_profile.valid?
    paru_profile.save!
    assert paru_profile.valid?
    assert_equal 'Name', paru_profile.name.to_s
  end
  
  test "address should give the entire address of the profile seperated by comma" do
    assert_equal 'St Teresas Convent, Convent Junction, Kochi, Kerala, India', @stTeresas.address.to_s
  end
  
  test "name should give the entire name of the user seperated by space" do
    assert_equal 'St. Teresas', @stTeresas.name.to_s
  end
end
