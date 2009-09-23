require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "invalid with null names" do
    name=Name.new('f','m','l')
    user=User.new(:email => "user@schoolarly.com")
    user.name=name
    assert !user.valid?
    #assert user.errors.invalid?(:name)
    #assert user.errors.valid?(:email)
  end
end

