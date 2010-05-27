unless User.find_by_email('admin@schoolarly.com')
  user = User.new(:email => 'admin@schoolarly.com', :password => 'dummy', :password_confirmation => 'dummy')
  user.crypted_password = '852b3fd79e82c5f32771f0908a842712c5f309ee93b837d2a8e935e486ccc3ba65f534541c13a74c6acf052679286823f346c1c922edeee643872e46a1fa56a8'
  user.password_salt = 'TtED8vt9xfr4izRfpMfz'
  user.person = SchoolarlyAdmin.new()
  user.save!
end
