require 'test_helper'

class UserProfileTest < ActiveSupport::TestCase
  
  def setup
    @paru=users(:paru)
  end
  
  test "a user can have only one profile & a profile belongs to one & only 1 user" do
    
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
  
end
